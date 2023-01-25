// SPDX-License-Identifier: GPL-3.0
pragma solidity >0.5.0;
contract DecentralisedKyc{

address RBI;
constructor (){
    RBI=msg.sender;
}

modifier OnlyRBI (){
    require(RBI==msg.sender,"Unauthorised operation");
    _;
}
//bank details
struct BankDetails{
    string bankName;
    address bankAddress;
    uint256 kycCount;
    bool addCustomerFunction;
    bool doKycFunction; 
}
//Customer details
struct CustomerDetails{
    string customerName;
    string customerDetails;
    address customerBankAddress;
    bool kycStatus;
}
mapping(address=>BankDetails)Bank;
mapping(string=>CustomerDetails)Customer;

//Adding new bank by RBI
function addBank(address _bankAddress,string memory _bankName) public OnlyRBI {
    Bank[_bankAddress]=BankDetails(_bankName,_bankAddress,0,true,true);
}

//Adding customer by Bank
function addCustomer(string memory _customerName,string memory _customerDetails)public{
    require(Bank[msg.sender].addCustomerFunction,"Unauthorised operation");
    Customer[_customerName]=CustomerDetails(_customerName,_customerDetails,msg.sender,false);
}

//Bank performing KYC
function performKyc(string memory _customerName) public {
    require(msg.sender==Customer[_customerName].customerBankAddress,"Unauthorised operation");
    require(Bank[msg.sender].doKycFunction,"You are blocked from performing KYC");
    Customer[_customerName].kycStatus=true;
    Bank[msg.sender].kycCount++;
}

//Check kyc status by bank
function checkKycStatus(string memory _customerName)public view returns(bool){
    require(msg.sender==Customer[_customerName].customerBankAddress,"Unauthorised Operation");
    return Customer[_customerName].kycStatus;
}

//RBI blocks bank from adding customer
function blockBankFromAddingCustomer(address _bankAddress)public OnlyRBI{
    Bank[_bankAddress].addCustomerFunction=false;
}

//RBI allows bank to add customer
function allowBankToAddCustomer(address _bankAddress)public OnlyRBI{
    Bank[_bankAddress].addCustomerFunction=true;
}

//RBI blocks bank from performing KYC
function blockBankFromPerformingKyc(address _bankAddress)public OnlyRBI{
    Bank[_bankAddress].doKycFunction=false;
}

//RBI revives back bank from performing KYC
function reviveBankFromPerformingKyc(address _bankAddress)public OnlyRBI{
    Bank[_bankAddress].doKycFunction=true;
}

//View details of the customer
function viewCustomerDetails(string memory _custName) public view returns(string memory,string memory,address,bool){
    return(Customer[_custName].customerName,
           Customer[_custName].customerDetails,
           Customer[_custName].customerBankAddress,
           Customer[_custName].kycStatus);
}

//View details of the bank
function viewBankDetails(address _bankAddress)public view OnlyRBI
returns(string memory,address,uint256,bool,bool){
    return(Bank[_bankAddress].bankName,
           Bank[_bankAddress].bankAddress,
           Bank[_bankAddress].kycCount,
           Bank[_bankAddress].addCustomerFunction,
           Bank[_bankAddress].doKycFunction);
}
}