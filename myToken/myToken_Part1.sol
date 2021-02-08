// SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.8.0;

contract myToken{
    mapping(address => uint256) private _balances;
    mapping (address => mapping(address => uint256)) private _permission;
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    uint256 private _totalSupply;
    
    constructor(
        uint256 _initialSupply,
        string memory tokenName,
        string memory tokenSymbol,
        uint8 decimalUnits
        ){
        _balances[msg.sender] = _initialSupply;
        _totalSupply = _initialSupply;
        _name = tokenName;
        _symbol = tokenSymbol;
        _decimals = decimalUnits;
    }
    
    event _transfer(address indexed sender, address indexed reciever, uint256 tokens);
    event _approve(address indexed owner, address indexed spender, uint256 tokens);
    // getters for the private variables
    function get_name() public view returns(string memory){
        return _name;
    }
    function get_symbol() public view returns(string memory){
        return _symbol;
    }
    function get_decimals() public view returns(uint8){
        return _decimals;
    }
    function get_totalSupply() public view returns(uint256){
        return _totalSupply;
    }
    function get_permission(address owner, address spender) public view returns(uint256){
        return _permission[owner][spender];
    }
    
    // setter for _totalSupply as other private variables will not change with time
    function set_totalSupply(uint256 totalAmount) internal {
        _totalSupply = totalAmount;
    }
    // setter for _permission
    function set_permission(address owner, address spender, uint256 amount) internal {
        _permission[owner][spender] = amount;
    }

    // ERC20 token function, which returns the token balance of an address. 
    function balanceOf(address tokenOwner) public view returns(uint256){
        return _balances[tokenOwner];
    }
    
    function setBalance(address account, uint256 balance) internal{
        _balances[account] = balance;
    }
    
    // ERC20 token function, which facilitates token transfer.
    function transfer(address beneficiary, uint256 amount) public returns(bool){
        require(beneficiary != address(0), "Beneficiary account can not be zero!");
        require(_balances[msg.sender] >= amount, "Sender does not have enough balance");
        require(_balances[beneficiary] + amount > _balances[beneficiary], "Addition Overflow");
        _balances[msg.sender] -= amount;
        _balances[beneficiary] += amount;
        emit _transfer(msg.sender, beneficiary, amount);
        return true;
    }
    
    // ERC20 token function, which facilitates the token transfer
    // by someone other than the account owner i.e. on behalf of the owner
    // if they have the right permissions.
    function approve(address spender, uint256 amount) public returns(bool success){
        require(spender != address(0), "Spender address can not be zero!");
        _permission[msg.sender][spender] = amount;
        emit _approve(msg.sender, spender, amount);
        return true;
    }
    
    // ERC20 token function which will facilitate the transfer
    // on behalf of owner by the spender to the beneficiary
    // of amount described by the permissions.
    function transferFrom(address owner, address beneficiary, uint256 amount) public returns(bool){
        require(owner != address(0), "Owner account can not be zero!");
        require(beneficiary != address(0), "Beneficiary account can not be zero!");
        require(_balances[owner] >= amount, "Sender does not have enough balance");
        require(_balances[beneficiary] + amount > _balances[beneficiary], "Addition Overflow");
        require(amount <= _permission[owner][msg.sender], "Spender does not have enough tokens approved to spend.");
        _balances[owner] -= amount;
        _permission[owner][msg.sender] -= amount;
        _balances[beneficiary] += amount;
        emit _transfer(owner, beneficiary, amount);
        return true;
    }
}