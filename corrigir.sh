#!/bin/bash
# =====================================================================
#  corrigir.sh — Remove a pasta OSINT (dado pessoal de terceiro) do
#  repositório e recria o histórico do Git limpo, sem material sensível.
#
#  ANTES de rodar: apague o repo no GitHub e recrie vazio (mesmo nome).
#  Uso: coloque na pasta Trabalhos e rode:   bash corrigir.sh
# =====================================================================
set -e
cd "$(dirname "$0")"
echo ">> Pasta: $(pwd)"

OSINT="M1 - D2 - Reconhecimento e Coleta de informação (OSINT)"
REPO_URL="https://github.com/victorcaldascds/pos-cybersecurity-offensive.git"

# Confere que está na pasta certa
if ! ls -d "M1 - D1"* >/dev/null 2>&1; then
  echo "!! Pasta errada. Coloque o corrigir.sh dentro de F:\\posgraduacao\\Aulas\\Trabalhos."
  exit 1
fi

# 1) Garante que a pasta OSINT fique FORA do Git (continua no disco)
touch .gitignore
if ! grep -qF "$OSINT" .gitignore; then
  {
    echo ""
    echo "# Trabalho de OSINT sobre pessoa real (Eduardo Paes) — NAO publicar"
    echo "/$OSINT/"
  } >> .gitignore
  echo ">> Pasta OSINT adicionada ao .gitignore."
else
  echo ">> OSINT ja estava no .gitignore."
fi

# 2) Recomeça o historico do zero (remove o commit que continha o OSINT)
echo ">> Limpando historico antigo do Git..."
rm -rf .git
git init
git branch -M main

# 3) Novo commit limpo (o .gitignore ja exclui a pasta OSINT)
git add .
git commit -m "Trabalhos da pos Cybersecurity Offensive (M1 e M2)"

# Confere que o OSINT NAO entrou
if git ls-files | grep -qF "$OSINT"; then
  echo "!! ATENCAO: a pasta OSINT ainda esta sendo rastreada. Abortando push."
  exit 1
fi
echo ">> Confirmado: nenhum arquivo da pasta OSINT entrou no commit."

# 4) Push para o repositorio recriado (vazio)
git remote add origin "$REPO_URL"
echo ">> Enviando para o GitHub..."
git push -u origin main

echo ""
echo "=============================================="
echo " OK! Repositorio republicado SEM o material de OSINT:"
echo "   https://github.com/victorcaldascds/pos-cybersecurity-offensive"
echo " A pasta OSINT continua no seu PC, apenas fora do Git."
echo "=============================================="
