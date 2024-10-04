// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SaveERC20 {
    address public owner;
    address tokenAddress;

    constructor(address _tokenAddress) {
        owner = msg.sender;
        tokenAddress = _tokenAddress;
    }
    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    event DepositSuccesful(address indexed user, uint indexed amount);
    event WithdrawSuccesful(address indexed user, uint indexed amount);
     event TransferSuccessful(address indexed from, address indexed _to, uint256 indexed amount);

    mapping(address => uint) balances;

    function deposit(uint256 _amount) external {
        require(msg.sender != address(0), "address zero detected");
        require(_amount > 0, "Cannot send zero amount");

        uint256 userTokenBalance = IERC20(tokenAddress).balanceOf(msg.sender);
        require(userTokenBalance >= _amount, "insufficient balance");

        IERC20(tokenAddress).transferFrom(msg.sender, address(this), _amount);
        balances[msg.sender] += _amount;
        emit DepositSuccesful(msg.sender, _amount);
    }

    function withdraw(uint _amount) external {
        require(msg.sender != address(0), "address zero decteted");
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        balances[msg.sender] -= _amount;
        IERC20(tokenAddress).transfer(msg.sender, _amount);
       emit  WithdrawSuccesful(msg.sender, _amount);
    }

    function myBalance() view external returns (uint256) {
        return balances[msg.sender];
    }

    function returnAnyBalance(address _user) external view  onlyOwner returns (uint256) {
        return balances[_user];
    }
    
    function returnAddressBalance() external view onlyOwner returns (uint) {
        return IERC20(tokenAddress).balanceOf(address(this));
    }

    function transferFund(address reciever, uint _amount) external {
        require(msg.sender != address(0), "address zero detected");
        require(reciever != address(0), "address zero detected");
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        require(_amount > 0, "Cannot send zero amount");

        balances[msg.sender] -= _amount;

        IERC20(tokenAddress).transfer(reciever, _amount);

        emit TransferSuccessful(msg.sender, reciever, _amount);
    }

    function depositForAnotherUserFromWithin(
        address _user,
        uint _amount
    ) external {
       require(msg.sender != address(0), "address zero detected");
        require(_user != address(0), "address zero detected");
        require(balances[msg.sender] >= _amount, "Insufficient balance");

        IERC20(tokenAddress).transferFrom(msg.sender, address(this), _amount);
        balances[_user] = balances[_user] + _amount;

    }

    function ownerWithdraw(uint256 _amount)external  {
      require(msg.sender != address(0), "address zero detected");
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        require(_amount > 0, "Cannot withdraw zero amount");
        balances[msg.sender] -= _amount;
        IERC20(tokenAddress).transfer(msg.sender, _amount);

    }
}
