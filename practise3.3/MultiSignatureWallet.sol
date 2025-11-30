// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MultiSigWallet {
    // 状态变量
    address[] public signers; // 签名者列表
    uint256 public threshold; // 所需确认阈值（至少n个签名）
    uint256 public transactionCount; // 交易提案计数器

    // 交易提案结构体
    struct Transaction {
        address to; // 接收地址
        uint256 value; // 转账金额（wei）
        bytes data; // 附加数据（可调用其他合约）
        bool executed; // 是否已执行
        uint256 confirmations; // 已确认次数
        mapping(address => bool) isConfirmed; // 记录每个签名者是否已确认
    }

    // 交易提案存储（ID => 交易）
    mapping(uint256 => Transaction) public transactions;

    // 事件定义
    event SignerAdded(address indexed signer);
    event ThresholdUpdated(uint256 newThreshold);
    event TransactionProposed(
        uint256 indexed txId,
        address indexed proposer,
        address indexed to,
        uint256 value,
        bytes data
    );
    event TransactionConfirmed(uint256 indexed txId, address indexed signer);
    event TransactionExecuted(uint256 indexed txId);

    // 修饰器：仅签名者可调用
    modifier onlySigner() {
        require(isSigner(msg.sender), "Not a signer");
        _;
    }

    // 修饰器：交易存在且未执行
    modifier validTransaction(uint256 txId) {
        require(txId < transactionCount, "Transaction does not exist");
        require(!transactions[txId].executed, "Transaction already executed");
        _;
    }

    // 构造函数：初始化签名者和阈值
    constructor(address[] memory initialSigners, uint256 initialThreshold) {
        require(initialSigners.length > 0, "At least one signer required");
        require(
            initialThreshold > 0 && initialThreshold <= initialSigners.length,
            "Invalid threshold"
        );

        // 添加初始签名者（去重）
        for (uint256 i = 0; i < initialSigners.length; i++) {
            address signer = initialSigners[i];
            require(signer != address(0), "Invalid signer address");
            if (!isSigner(signer)) {
                signers.push(signer);
            }
        }

        threshold = initialThreshold;
    }

    // 检查地址是否为签名者
    function isSigner(address account) public view returns (bool) {
        for (uint256 i = 0; i < signers.length; i++) {
            if (signers[i] == account) {
                return true;
            }
        }
        return false;
    }

    // 获取所有签名者
    function getSigners() public view returns (address[] memory) {
        return signers;
    }

    // 添加新签名者（仅现有签名者可操作）
    function addSigner(address newSigner) public onlySigner {
        require(newSigner != address(0), "Invalid signer address");
        require(!isSigner(newSigner), "Already a signer");
        signers.push(newSigner);
        emit SignerAdded(newSigner);
    }

    // 更新确认阈值（仅现有签名者可操作）
    function updateThreshold(uint256 newThreshold) public onlySigner {
        require(
            newThreshold > 0 && newThreshold <= signers.length,
            "Invalid threshold"
        );
        threshold = newThreshold;
        emit ThresholdUpdated(newThreshold);
    }

    // 创建交易提案（仅签名者可操作）
    function proposeTransaction(
        address to,
        uint256 value,
        bytes memory data
    ) public onlySigner returns (uint256 txId) {
        require(to != address(0), "Invalid target address");
        txId = transactionCount;

        // 初始化交易提案
        Transaction storage txn = transactions[txId];
        txn.to = to;
        txn.value = value;
        txn.data = data;
        txn.executed = false;
        txn.confirmations = 0;

        transactionCount++;
        emit TransactionProposed(txId, msg.sender, to, value, data);
    }

    // 确认交易提案（仅签名者可操作，不可重复确认）
    function confirmTransaction(uint256 txId)
        public
        onlySigner
        validTransaction(txId)
    {
        Transaction storage txn = transactions[txId];
        require(!txn.isConfirmed[msg.sender], "Already confirmed");

        txn.isConfirmed[msg.sender] = true;
        txn.confirmations++;

        emit TransactionConfirmed(txId, msg.sender);

        // 达到阈值自动执行
        if (txn.confirmations >= threshold) {
            executeTransaction(txId);
        }
    }

    // 执行交易（内部函数，仅在确认阈值达标后调用）
    function executeTransaction(uint256 txId) internal validTransaction(txId) {
        Transaction storage txn = transactions[txId];
        require(txn.confirmations >= threshold, "Insufficient confirmations");

        // 标记为已执行（防止重入）
        txn.executed = true;

        // 执行转账/合约调用
        (bool success, ) = txn.to.call{value: txn.value}(txn.data);
        require(success, "Transaction execution failed");

        emit TransactionExecuted(txId);
    }

    // 查看交易详情（包含确认状态）
    function getTransactionDetails(uint256 txId)
        public
        view
        returns (
            address to,
            uint256 value,
            bytes memory data,
            bool executed,
            uint256 confirmations
        )
    {
        require(txId < transactionCount, "Transaction does not exist");
        Transaction storage txn = transactions[txId];
        return (
            txn.to,
            txn.value,
            txn.data,
            txn.executed,
            txn.confirmations
        );
    }

    // 检查地址是否已确认某笔交易
    function hasConfirmed(uint256 txId, address signer)
        public
        view
        returns (bool)
    {
        require(txId < transactionCount, "Transaction does not exist");
        return transactions[txId].isConfirmed[signer];
    }

    // 接收ETH（钱包支持直接接收转账）
    receive() external payable {}
}