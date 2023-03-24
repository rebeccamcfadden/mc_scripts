@echo off
SetLocal EnableDelayedExpansion

echo Switching to main branch and updating

cd /d %MC_MAIN%

refreshBranch %*