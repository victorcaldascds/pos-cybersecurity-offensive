#!/bin/bash
# =====================================================================
#  subir.sh  —  Versiona a pasta de Trabalhos da pós e sobe pro GitHub
#  Uso:  coloque este arquivo em  F:\posgraduacao\Aulas\Trabalhos
#        abra o Git Bash nessa pasta e rode:   bash subir.sh
# =====================================================================
set -e

# Ir para a pasta onde o script está (a pasta Trabalhos)
cd "$(dirname "$0")"
echo ">> Pasta: $(pwd)"

# Conferência de segurança: estamos mesmo na pasta certa?
if ! ls -d "M1 - D1"* >/dev/null 2>&1; then
  echo "!! Não encontrei as pastas 'M1 - D...' aqui."
  echo "!! Coloque o subir.sh DENTRO de F:\\posgraduacao\\Aulas\\Trabalhos e rode de novo."
  exit 1
fi

REPO_URL="https://github.com/victorcaldascds/pos-cybersecurity-offensive.git"

# ---------------------------------------------------------------- README.md
cat > README.md <<'EOF'
# Pós-graduação — Cybersecurity Offensive: Pentest & Red Team

Trabalhos, laboratórios e relatórios da minha pós-graduação em
**Cybersecurity Offensive: Pentest & Red Team**, organizados por módulo (M) e
disciplina (D).

> ⚠️ **Ética e escopo** — Todo o material foi produzido em **ambientes de
> laboratório controlados e autorizados** (OWASP Juice Shop, DVWA, PortSwigger
> Web Security Academy, OopsSec Store e cenários fictícios do curso) ou como
> exercício acadêmico. Nada aqui deve ser executado contra sistemas sem
> autorização explícita por escrito.

---

## Módulo 1

| Disciplina | Conteúdo |
|---|---|
| **M1-D1** — Fundamento de Hacking Ético e Metodologias de Pentest | Termo de Engajamento (pentest simulado — DiscadaNet) |
| **M1-D2** — Reconhecimento e Coleta de Informação (OSINT) | Atividade e Trabalho de OSINT |
| **M1-D3** — Scanning e Enumeração de Vulnerabilidades | Trabalho de Scanning e Enumeração |
| **M1-D4** — Ataques de Engenharia Social | Spear phishing (Modelo A) — cenário fictício NortePay |
| **M1-D5** — Exploração de Vulnerabilidade Web e API | Laboratórios 1–8 + Projeto Final (OopsSec Store) |

### M1-D5 — Laboratórios

| Lab | Tema | Ambiente |
|-----|------|----------|
| Lab 1 | Attack Surface Mapping | OWASP Juice Shop |
| Lab 2 | BOLA / Broken Object Level Authorization | API (OWASP API1:2023) |
| Lab 3 | SQL Injection (login) | OWASP Juice Shop |
| Lab 4 | Command Injection | DVWA |
| Lab 5 | XSS / DOM XSS | OWASP Juice Shop |
| Lab 6 | CSRF | DVWA |
| Lab 7 | Path Traversal / LFI + File Upload | DVWA |
| Lab 8 | SSRF | PortSwigger Web Security Academy |
| Projeto Final | Pentest completo (5+ vulnerabilidades) | OopsSec Store |

## Módulo 2

| Disciplina | Conteúdo |
|---|---|
| **M2-D1** — Ataques em Redes sem Fio | Em andamento |

---

Autor: **Victor Caldas dos Santos** · GitHub: [@victorcaldascds](https://github.com/victorcaldascds)
EOF
echo ">> README.md criado."

# ---------------------------------------------------------------- .gitignore
cat > .gitignore <<'EOF'
# ===== Pentest — nunca versionar material sensível =====
# Imagens de VM / discos
*.vdi
*.vmdk
*.ova
*.ovf
*.vbox
*.vbox-prev

# Segredos e credenciais
.env
.env.*
*.pem
*.key
id_rsa
id_rsa.*
*.kdbx
*secret*
*password*.txt
creds*.txt
credentials*.txt

# Capturas e dumps brutos (reveja antes de versionar manualmente)
*.pcap
*.pcapng
dump*.sql
*.dump
loot/
raw/

# Arquivo de projeto do Burp (pode conter sessões/tokens)
*.burp

# ===== Lixo de SO / editor =====
.DS_Store
Thumbs.db
desktop.ini
*~
*.swp
.idea/
.vscode/

# ===== Node / builds de alvos clonados =====
node_modules/
dist/
build/
__pycache__/
*.pyc
EOF
echo ">> .gitignore criado."

# Manter pastas vazias no git (ex.: M2-D1 ainda sem arquivos)
find . -type d -empty -not -path './.git/*' -exec touch {}/.gitkeep \; 2>/dev/null || true

# ---------------------------------------------------------------- git
if [ ! -d .git ]; then
  git init
  git branch -M main
fi

git add .
git commit -m "Trabalhos da pós Cybersecurity Offensive (M1 e M2)" || echo ">> (nada novo para commitar)"

if ! git remote | grep -q '^origin$'; then
  git remote add origin "$REPO_URL"
else
  git remote set-url origin "$REPO_URL"
fi

echo ">> Enviando para o GitHub (vai abrir o navegador para login na 1a vez)..."
git push -u origin main

echo ""
echo "=============================================="
echo " Pronto! Repositório publicado em:"
echo "   https://github.com/victorcaldascds/pos-cybersecurity-offensive"
echo "=============================================="
