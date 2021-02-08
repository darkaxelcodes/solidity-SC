// SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.8.0;
contract administrable{
    address private _admin;
    event _adminRightsTransfer(address indexed currentAdmin, address indexed newAdmin);
    
    constructor() {
        _admin = msg.sender;
    }
    function get_admin() public view returns(address){
        return _admin;
    }
    modifier onlyAdmin(){
        require(msg.sender == _admin, "Action can only be performed by Admin");
        _;
    }
    function adminRightsTransfer(address newAdmin) public onlyAdmin{
        emit _adminRightsTransfer(_admin, newAdmin);
        _admin = newAdmin;
    }
}
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

    // ERC20 token function, which returns the ttal token supply.
    function totalSupply() public view returns(uint256){
        return _totalSupply;
    }
    // ERC20 token function, which returns the token balance of an address. 
    function balanceOf(address tokenOwner) public view returns(uint256){
        return _balances[tokenOwner];
    }
    
    function setBalance(address account, uint256 balance) internal{
        _balances[account] = balance;
    }
    
    // ERC20 token function, which facilitates token transfer.
    function transfer(address beneficiary, uint256 amount) public virtual returns(bool){
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
    function approve(address spender, uint256 amount) public virtual returns(bool success){
        require(spender != address(0), "Spender address can not be zero!");
        _permission[msg.sender][spender] = amount;
        emit _approve(msg.sender, spender, amount);
        return true;
    }
    
    // ERC20 token function which will facilitate the transfer
    // on behalf of owner by the spender to the beneficiary
    // of amount described by the permissions.
    function transferFrom(address owner, address beneficiary, uint256 amount) public virtual returns(bool){
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

contract myTokenAdvanced is administrable, myToken{
    mapping(address => bool) private _frozenAccounts;
    mapping(address => uint) private _pendingWithdrawls;
    uint256 private _sellPrice = 1; // ether per token  
    uint256 private _buyPrice = 1; // ether per token
    event _frozen(address target, bool frozen);
    constructor(
        uint256 initialSupply,
        string memory tokenName,
        string memory tokenSymbol,
        uint8 decimalUnits,
        address newAdmin
        )
        myToken(0, tokenName, tokenSymbol, decimalUnits){
            if (newAdmin != address(0) && newAdmin != msg.sender)
                adminRightsTransfer(newAdmin);
            setBalance(newAdmin, initialSupply);
            set_totalSupply(initialSupply);
        }
        function get_sellPrice() public view returns(uint256){
            return _sellPrice;
        }
        
        function get_buyPrice() public view returns(uint256){
            return _buyPrice;
        }
        
        function setPrice(uint256 newSellPrice, uint256 newBuyPrice) public onlyAdmin{
            require(newBuyPrice > 0, "Buy price can not be less than zero!");
            require(newSellPrice > 0, "Sell price can not be less than zero!");
            _sellPrice = newSellPrice;
            _buyPrice = newBuyPrice;
        }
        
        function mintToken(address target, uint256 mintedTokens) public onlyAdmin{
            require(balanceOf(target) + mintedTokens > balanceOf(target), "Addition Overflow!");
            require(totalSupply() + mintedTokens > totalSupply(), "Addition Overflow!");
            setBalance(target, balanceOf(target) + mintedTokens);
            set_totalSupply(balanceOf(target) + mintedTokens);
            emit _transfer(address(0), target, mintedTokens);
        }
        
        function freezeAccount(address target, bool freeze) public onlyAdmin{
            _frozenAccounts[target] = freeze;
            emit _frozen(target, freeze);
        }
        
        function transfer(address beneficiary, uint256 amount) override public returns(bool){
        require(beneficiary != address(0), "Beneficiary account can not be zero!");
        require(balanceOf(msg.sender) >= amount, "Sender does not have enough balance");
        require(balanceOf(beneficiary) + amount > balanceOf(beneficiary), "Addition Overflow");
        require(!_frozenAccounts[msg.sender], "your account is frozen!");
        require(!_frozenAccounts[beneficiary], "Beneficiary is frozen!");
        setBalance(msg.sender, balanceOf(msg.sender) - amount);
        setBalance(beneficiary, balanceOf(beneficiary) + amount);
        emit _transfer(msg.sender, beneficiary, amount);
        return true;
    }
    
    function transferFrom(address owner, address beneficiary, uint256 amount) public override returns(bool){
        require(owner != address(0), "Owner account can not be zero!");
        require(beneficiary != address(0), "Beneficiary account can not be zero!");
        require(balanceOf(owner) >= amount, "Sender does not have enough balance");
        require(balanceOf(beneficiary) + amount > balanceOf(beneficiary), "Addition Overflow");
        require(amount <= get_permission(owner, msg.sender), "Spender does not have enough tokens approved to spend.");
        require(!_frozenAccounts[owner], "Your account is frozen!");
        require(!_frozenAccounts[beneficiary], "Beneficiary is frozen!");
        setBalance(owner, balanceOf(owner) - amount);
        set_permission(owner, msg.sender, get_permission(owner, msg.sender) - amount);
        setBalance(beneficiary, balanceOf(beneficiary) + amount);
        emit _transfer(owner, beneficiary, amount);
        return true;
    }
    
    function approve(address spender, uint256 amount) public override returns(bool success){
        require(spender != address(0), "Spender address can not be zero!");
        require(!_frozenAccounts[spender], "Account is frozen!");
        set_permission(msg.sender, spender, amount);
        emit _approve(msg.sender, spender, amount);
        return true;
    }
    
    function buy() public payable{
        uint256 tokens = (msg.value/(1 ether)) / _buyPrice;
        address thisContractAddress = address(this);
        require(balanceOf(thisContractAddress) > tokens, "Token balance low!");
        require(balanceOf(msg.sender) + tokens > balanceOf(msg.sender), "Addition Overflow");
        setBalance(thisContractAddress, balanceOf(thisContractAddress) - tokens);
        setBalance(msg.sender, balanceOf(msg.sender) + tokens);
        emit _transfer(thisContractAddress, msg.sender, tokens);
    }
    
    function sell(uint256 tokens) public {
        address thisContractAddress = address(this);
        require(balanceOf(msg.sender) >= tokens, "Token balance low!");
        require(balanceOf(thisContractAddress) + tokens > balanceOf(thisContractAddress), "Addition Overflow!");
        setBalance(msg.sender, balanceOf(msg.sender) - tokens);
        setBalance(thisContractAddress, balanceOf(thisContractAddress) + tokens);
        uint256 ethersToSend = tokens * _sellPrice * (1 ether);
        _pendingWithdrawls[msg.sender] += ethersToSend;
        emit _transfer(msg.sender, thisContractAddress, tokens);
    }
    
    function withdraw() public{
        uint256 amount = _pendingWithdrawls[msg.sender];
        _pendingWithdrawls[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
}