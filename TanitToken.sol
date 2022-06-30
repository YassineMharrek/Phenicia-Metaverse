// SPDX-License-Identifier: MIT LICENSE

pragma solidity 0.8.4;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TanitToken is ERC20, ERC20Burnable, Ownable {
  using SafeMath for uint256;

  mapping(address => uint256) private _balances;
  mapping(address => bool) controllers;
  uint256 private _totalSupply;
  uint256 private MAXSUP;
  //date date=getTime()
  //Our maximum supply is 10 Billion token (it will be stored in a constant MAXIMUMSUPPLY)

  //We need to convert 10 Billion to Wei (smallest decimal value)

  uint256 constant MAXIMUMSUPPLY=10000000000*10**18;


 //Our initial supply is 350 Million

  constructor() ERC20("TANIT", "TNT") { 
      _mint(msg.sender, 350000000 * 10 ** 18);

  }

  //Minting TNT token can only be done via staking or owner
  function mint(address to, uint256 amount) external {
    require(controllers[msg.sender] || msg.sender == owner, "Minting is done only by owner or staking");
    require((MAXSUP+amount)<=MAXIMUMSUPPLY,"Maximum supply has been reached");
    _totalSupply = _totalSupply.add(amount);
    MAXSUP=MAXSUP.add(amount);
    _balances[to] = _balances[to].add(amount);
    _mint(to, amount);
  }

  //Minting the shares of the team
    function airdropMinting([]address _to_list, uint amount) public {
    require(msg.sender == owner, "Minting shares is done only by owner");
    require((MAXSUP+amount)<=MAXIMUMSUPPLY,"Maximum supply has been reached");
    amount=totalSupply*15/100;
    _totalSupply = _totalSupply.add(amount);
    MAXSUP=MAXSUP.add(amount);
    _balances[to] = _balances[to].add(amount);
    for (uint i = 0; i < _to_list.length; i++) {
      _mint(_to_list[i], amount/7);
    }
  }

  
  function burnFrom(address account, uint256 amount) public override {
      if (controllers[msg.sender]) {
          _burn(account, amount);
      }
      else {
          super.burnFrom(account, amount);
      }
  }

  function addController(address controller) external onlyOwner {
    controllers[controller] = true;
  }

  function removeController(address controller) external onlyOwner {
    controllers[controller] = false;
  }
  
  function totalSupply() public override view returns (uint256) {
    return _totalSupply;
  }

  function maxSupply() public  pure returns (uint256) {
    return MAXIMUMSUPPLY;
  }

}