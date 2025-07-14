#!/bin/zsh

echo "=== Testing dotfiles interactive shell protection ==="
echo

echo "1. Testing non-interactive shell startup time:"
time_result=$(time zsh -c 'source ~/.zshrc && exit' 2>&1)
echo "   $time_result"
if [[ "$time_result" == *"0.0"*"total"* ]]; then
  echo "   ✅ Fast startup (< 0.1s)"
else
  echo "   ⚠️  Startup time: check if acceptable"
fi

echo
echo "2. Testing non-interactive prompt:"
result=$(zsh -c 'source ~/.zshrc && echo "PROMPT=$PROMPT"' 2>/dev/null)
echo "   $result"
if [[ "$result" == "PROMPT=\$ " ]]; then
  echo "   ✅ Non-interactive prompt is simple"
else
  echo "   ❌ Non-interactive prompt is complex: $result"
fi

echo
echo "3. Testing git prompt function in non-interactive:"
git_test=$(zsh -c 'source ~/.zshrc && git_prompt_info; echo "exit_code:$?"' 2>/dev/null)
echo "   $git_test"
if [[ "$git_test" == "exit_code:0" ]]; then
  echo "   ✅ Git prompt function returns cleanly"
else
  echo "   ❌ Git prompt function has issues: $git_test"
fi

echo
echo "4. Testing interactive detection:"
interactive_test=$(zsh -c 'source ~/.zshrc && [[ -o interactive ]] && echo "INTERACTIVE" || echo "NON-INTERACTIVE"')
echo "   Mode detected: $interactive_test"
if [[ "$interactive_test" == "NON-INTERACTIVE" ]]; then
  echo "   ✅ Correctly detected non-interactive mode"
else
  echo "   ❌ Failed to detect mode correctly"
fi

echo
echo "5. Testing current shell (should be interactive):"
if [[ -o interactive ]]; then
  echo "   ✅ Current shell is interactive"
  echo "   Your prompt should have git info and starship styling"
else
  echo "   ❌ Current shell is not interactive"
fi

echo
echo "6. Testing tool availability in current shell:"
tools_available=""
[[ -n "$NVM_DIR" ]] && tools_available+="nvm "
type starship &>/dev/null && tools_available+="starship "
type mise &>/dev/null && tools_available+="mise "
type direnv &>/dev/null && tools_available+="direnv "
type atuin &>/dev/null && tools_available+="atuin "

if [[ -n "$tools_available" ]]; then
  echo "   ✅ Available tools: $tools_available"
else
  echo "   ⚠️  No interactive tools detected"
fi

echo
echo "=== Protected Elements ==="
echo "   📦 NVM loading"
echo "   🎨 Starship prompt"
echo "   🔧 mise/direnv/atuin hooks"
echo "   📂 Z jump navigation"
echo "   ☁️  Azure CLI completion"
echo "   🎯 Git prompt commands"
echo "   🔍 FZF setup"
echo
echo "=== Test complete ==="
