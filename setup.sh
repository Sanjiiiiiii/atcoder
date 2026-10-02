#!/usr/bin/env bash
set -e
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"

# 1. conda 環境
conda env create -f "$REPO_DIR/environment.yml" || conda env update -f "$REPO_DIR/environment.yml"

# 2. atcoder-cli（Node.js が必要）
npm install -g atcoder-cli

# 3. テンプレート配置
CONF="$(acc config-dir)"
mkdir -p "$CONF/cpp"
cp "$REPO_DIR/template/main.cpp" "$REPO_DIR/template/template.json" "$CONF/cpp/"

# 4. acc の設定（oj のパスはマシンごとに違うので動的に取る）
acc config oj-path "$(which oj)"
acc config default-template cpp
acc config default-task-dirname-format "{tasklabel}"
acc config default-test-dirname-format tests
acc config default-task-choice all

# 5. bashrc に new() を追加（未登録の場合のみ）
if ! grep -q '^new()' ~/.bashrc; then
cat >> ~/.bashrc <<'EOF'

# acc new と移動をセットにする
new() {
  acc new abc"$1" && cd abc"$1"/a
}
EOF
fi

echo "完了。次を手動で実行してください: conda activate atcoder && acc login"