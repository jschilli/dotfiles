#/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
docker run --rm -it -d \
    -p 18888:18888 \
    -p 4317:18889 \
    --name aspire-dashboard \
    mcr.microsoft.com/dotnet/aspire-dashboard:latest


loginLine=$(docker container logs aspire-dashboard | grep "login?t=")
match=$(echo "$loginLine" | sed -n 's/.*login?t=\([^[:space:]]*\).*/\1/p')
echo -n "$match" | pbcopy
echo "Login URL: https://localhost:18888/ key copied to clipboard: $match"