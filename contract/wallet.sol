pragma solidity ^0.4.0;

contract Wallet{
    
    address owner;
    struct properties{
        bool isAllowed;
        uint256 maxTransaction;
    }
    mapping(address=>properties) permissions;
   
    constructor() public {
        owner = msg.sender;
        permissions[owner]=properties(true,90000000000000000000);
    }
    
    modifier onlyOwner(){
         require(
            msg.sender == owner,"You are not allowed to access this section."
            );
            _;
    }
    event transactionStatus(address sender,bool transationLimitCrossed,bool transactionSuccessful);
    
    function addToWallet(address permitted,uint256 maxLimit) public onlyOwner{
        permissions[permitted].isAllowed = true;
        permissions[permitted].maxTransaction = maxLimit;
        
    }
    
    function sendFunds(address receiver,uint256 amountToSend) public{
        require(
            address(this).balance != 0,"Unsufficient balance! Contact owner to add more funds."
            );
        if(permissions[msg.sender].maxTransaction < amountToSend){
            emit transactionStatus(msg.sender,true,false);
            revert();
        }
        else{
            receiver.transfer(amountToSend);
        }
    }
    
    function addFund() public onlyOwner payable{}
    
    function getBalance() public constant returns(uint){
        return address(this).balance;
    }
}
