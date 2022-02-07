pragma solidity ^0.8.10;
import "@openzeppelin/contracts/access/Ownable.sol"; 
import "@openzeppelin/contracts/utils/SafeMath.sol";

contract ShareWallet is Ownable {

    using SafeMath for uint;
    event MonerySent(address indexed _beneficiary, uint _amount);
    event MoneryReceived(address indexed _from, uint _amount); 
    event AllowanceChanged(address indexed _forWho,address indexed _fromWhome, uint _oldAmount, uint _newAmount);

    mapping(address => uint) public allowance;

    function addAllowance(address _who, unit _amount) public onlyOwner{
        emit AllowanceChanged(_who,msg.sender,allowance[_who],_amount);
        allowance[_who] = _amount;
    }

    modifier ownerOrAllowed(unit _amount){
        require(isOwner()||allowance[msg.sender]>=_amount,"You are not allowed");
        _;
    }

    function reduceAllowance(address _who, uint _amount) internal {
        emit AllowanceChanged(_who,msg.sender,allowance[_who], allowance[_who].sub(_amount));
        allowance[_who] =  allowance[_who].sub(_amount);
    }

    function withDrawMoney(address payable _to, uint _amount) public ownerOrAllowed(_amount){
        require(_amount<= address(this).balance, "There are not enough funds stored in the smart contract");
        if(!isOwner()){
            reduceAllowance(msg.sender, _amount);
        }
        emit MonerySent(_to,_amount);
        _to.transfer(_amount);
    }

    function renounceOwnership() public onlyOwner{
        revert("Can't renouce owershio here");
    }

    function () external payable {
        emit MoneryReceived(msg.sender, msg.value);
    }
}