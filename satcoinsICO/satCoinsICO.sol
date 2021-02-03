
// satcoins ICO
// SPDX-License-Identifier: UNLICENSED
// Version of the compiler
pragma solidity >=0.4.16 <0.9.0;

contract satcoins_ico
{
    // Introducing the total no. of satcoins available for sale
    uint public max_satcoins = 1000000;
    
    // Introducing the USD to satcoins conversion relocatable
    uint public usd_to_satcoins = 1000;
    
    // Introducing the total no. of satcoins that have been bought by the investors.
    uint public total_satcoins_bought = 0;
    
    // Mapping from investor address to its equity in satcoins and USD
    mapping(address => uint) equity_satcoins;
    mapping(address => uint) equity_usd;
    
    // Checking if an investor can buy satcoins
    modifier can_buy_satcoins(uint usd_invested)
    {
        require(usd_invested * usd_to_satcoins + total_satcoins_bought <= max_satcoins);
        _;
    }
    
    // Getting the equity in satcoins of the investor
    function equity_in_satcoins(address investor) external view returns(uint)
    {
        return equity_satcoins[investor];
    }
    
    // Getting the equity in USD of the investor
    function equity_in_usd(address investor) external view returns(uint)
    {
        return equity_usd[investor];
    }
    // Buying satcoins
    function buy_satcoins(address investor, uint usd_invested) external 
    can_buy_satcoins(usd_invested)
    {
        uint satcoins_bought = usd_invested * usd_to_satcoins;
        equity_satcoins[investor] += satcoins_bought;
        equity_usd[investor] += equity_satcoins[investor]/usd_to_satcoins;
        total_satcoins_bought += satcoins_bought;
    }
    
    //Selling satcoins
    function sell_satcoins(address investor, uint satcoins_sold) external 
    {
        equity_satcoins[investor] -= satcoins_sold;
        equity_usd[investor] += equity_satcoins[investor]/usd_to_satcoins;
        total_satcoins_bought -= satcoins_sold;
    }
    
}