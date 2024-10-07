cd /home/vscode/ssl-certificates && ./apply_certificates.sh
git config --global --add safe.directory /workspaces/stroma
git config --global init.defaultBranch main
cd /workspaces/stroma
pre-commit install

cat >> ~/.inputrc <<'EOF'
"\e[A": history-search-backward
"\e[B": history-search-forward
EOF
