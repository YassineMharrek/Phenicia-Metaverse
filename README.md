# Phenicia Metaverse

Implementing our ERC-20 token Tanit(TNT) and creating the necessary staking mechanisms 

The primary benefit of staking is that you earn more crypto, and interest rates can be generous. In some cases, you can earn more than 10% or 20% per year. It's potentially a very profitable way to invest your money. And, the only thing you need is crypto that uses the proof-of-stake model. Anyhow, in our project case, staking will encourage early adopters and venture investors to hold their TANIT(TNT) assets and earn very generous returns for up to 60% per year in early years of development and that will ensure two things:

* Financial growing for our metaverse eco-system and improving and growing. 
* Financial benefits for early investors and people who trust in our vision.  
  
To build our tokenomics, we will need:
* To create firstly our ERC-20 token.
* Data structures to keep track of stakes, stakeholders and rewards.
* Methods to create and remove stakes.
* A rewards system.

# Creation of our ERC-20 Tanit token 

```
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
 
  //Our maximum supply is 10 Billion token (it will be stored in a constant MAXIMUMSUPPLY)

  //We need to convert 10 Billion to Wei (smallest decimal value)

  uint256 constant MAXIMUMSUPPLY=10000000000*10**18;

 //Our initial supply is 1.350 Billion

  constructor() ERC20("TANIT", "TNT") { 
      _mint(msg.sender, 1350000000 * 10 ** 18);

  }

  //Minting TNT token can only be done via staking 
  function mint(address to, uint256 amount) external {
    require(controllers[msg.sender], "Minting is done only by staking");
    require((MAXSUP+amount)<=MAXIMUMSUPPLY,"Maximum supply has been reached");
    _totalSupply = _totalSupply.add(amount);
    MAXSUP=MAXSUP.add(amount);
    _balances[to] = _balances[to].add(amount);
    _mint(to, amount);
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

```

# Implementing the staking mechanisms

Now that we created our token, we need to implement the staking mechanisms to reward holders of TNT.


# Stakeholders
We need to track our stakeholders and in order to do that, we will create a dynamic array that contains their adresses.
```
 address[] internal stakeholders;
```
