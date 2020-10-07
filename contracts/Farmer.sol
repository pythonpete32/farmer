pragma solidity ^0.6.0;

import './token/ERC20/IERC20.sol';
import '../interfaces/Icomptroller.sol';
import '../interfaces/IcToken.sol';

contract Farmer {
  Icomptroller comptroller;
  IcToken cDai;
  IERC20 dai;
  IERC20 uni;
  IERC20 comp;
  uint borrowFactor = 70;

  constructor() public {
    comptroller = Icomptroller(0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B);
    cDai = IcToken(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);
    dai = IERC20(0x6b175474e89094c44da98b954eedeac495271d0f);
    uni = IERC20(0x1f9840a85d5af5bf1d1762f925bdaddc4201f984);
    comp = IERC20(0xc00e94cb662c3520282e6f5717214004a7f26888);
    address[] memory cTokens = new address[](1);
    cTokens[0] = cDaiAddress; 
    comptroller.enterMarkets(cTokens);
  }

  function openPosition(uint initialAmount) external {
    uint nextCollateralAmount = initialAmount;
    for(uint i = 0; i < 5; i++) {
      nextCollateralAmount = _supplyAndBorrow(nextCollateralAmount);
    }
  }

  function _supplyAndBorrow(uint collateralAmount) internal returns(uint) {
    dai.approve(address(cDai), collateralAmount);
    cDai.mint(collateralAmount);
    uint borrowAmount = (collateralAmount * 70) / 100;
    cDai.borrow(borrowAmount);
    return borrowAmount;
  }

  function closePosition() external {
    uint balanceBorrow = cDai.borrowBalanceCurrent(address(this));
    dai.approve(address(cDai), balanceBorrow);
    cDai.repayBorrow(balanceBorrow);
    uint balancecDai = cDai.balanceOf(address(this));
    cDai.redeem(balancecDai);
  }
}