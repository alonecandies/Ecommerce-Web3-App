// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Store {
  constructor(
    string memory _storeName,
    address _storeOwner,
    uint256 _feePercent
  ) {
    storeName = _storeName;
    storeOwner = _storeOwner;
    feePercent = _feePercent;
    storeAcc = 0;
  }

  address public immutable storeOwner;
  uint256 public storeAcc;
  string public storeName;
  uint256 public immutable feePercent;
  uint256 public storeSales;

  mapping(address => uint256) public salesOf;

  event Sale(address indexed buyer, address indexed seller, uint256 amount, uint256 timestamp);
  event Withdrawal(address indexed receiver, uint256 amount, uint256 timestamp);

  struct SalesStruct {
    address buyer;
    address seller;
    uint256 amount;
    string purpose;
    uint256 timestamp;
  }
  SalesStruct[] sales;

  function _payTo(address _to, uint256 _amount) internal {
    (bool success1, ) = payable(_to).call{ value: _amount }('');
    require(success1);
  }

  function withdrawMoneyTo(address receiver, uint256 amount) internal returns (bool success) {
    require(storeAcc >= amount, 'Insufficent Fund!');
    _payTo(receiver, amount);
    storeAcc -= amount;

    // Captures transfer data on event
    emit Withdrawal(receiver, amount, block.timestamp);
    return true;
  }

  function getAllSales() public view returns (SalesStruct[] memory) {
    return sales;
  }

  function payNow(address seller, string memory purpose) public payable returns (bool success) {
    // Validating payments
    require(msg.value > 0, 'Ethers cannot be zero!');
    require(msg.sender != storeOwner, 'Sale Not allowed');

    // Calculating up cost and fee
    uint256 fee = (msg.value / 100) * feePercent;
    uint256 cost = msg.value - fee;

    // Assigning sales and payment to store and product owner
    storeAcc += msg.value;
    storeSales += 1;
    salesOf[seller] += 1;

    // Cashing out to sales party
    withdrawMoneyTo(storeOwner, fee);
    withdrawMoneyTo(seller, cost);

    // Recording sales in smart contract
    sales.push(SalesStruct(msg.sender, seller, cost, purpose, block.timestamp));

    // Captures sales data on event
    emit Sale(msg.sender, seller, cost, block.timestamp);
    return true;
  }
}
