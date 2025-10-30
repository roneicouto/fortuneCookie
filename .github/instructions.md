# Prompt de Projeto: Biscoitinhos da Sorte

## 1. Objetivo

Criar uma página web de uma única tela chamada "Biscoitinhos da Sorte". A página exibirá um biscoito da sorte que, ao ser interagido pelo usuário, se "abre" para revelar uma frase de sabedoria.

## 2. Stack Tecnológica

* **HTML:** Estrutura semântica básica.
* **CSS:** **Tailwind CSS** (via CDN, para agilidade e praticidade no design responsivo e estilização).
* **JavaScript:** **Vanilla JS (Puro)**. É a opção mais prática e leve, pois o projeto consiste em manipulação direta do DOM e gerenciamento de eventos simples, não necessitando do *overhead* de um framework.

## 3. Estrutura de Arquivos

Gere todo o código em um **único arquivo `index.html`**. Isso inclui:
1.  O HTML da estrutura.
2.  O link para o CDN do Tailwind CSS no `<head>`.
3.  Uma tag `<style>` para CSS customizado (se necessário, como animações).
4.  Uma tag `<script>` no final do `<body>` contendo toda a lógica JavaScript.

## 4. Requisitos Funcionais e de Design

### Layout (HTML e Tailwind)
* O layout deve ser totalmente centralizado na tela (horizontal e verticalmente).
* Utilize classes do Tailwind (ex: `flex`, `items-center`, `justify-center`, `h-screen`, `bg-gray-100` ou um fundo temático).
* A página deve conter dois elementos principais, empilhados verticalmente (ex: `flex-col`, `gap-4`):
    1.  **Área do Biscoito (`#cookie-wrapper`):** Onde a imagem do biscoito será exibida.
    2.  **Área da Frase (`#fortune-display`):** Um `div` que conterá a frase.

### Elementos e Estados
1.  **Biscoito (`#cookie-img`):**
    * Este será um elemento `<img>`.
    * **Estado Inicial (Fechado):** Deve exibir uma imagem de um biscoito da sorte fechado (use um placeholder ou sugira o nome `cookie-fechado.png`).
    * **Estado Final (Aberto):** Ao ser ativado, a imagem deve ser trocada por uma de um biscoito aberto com a sorte saindo (use um placeholder ou sugira `cookie-aberto.png`).
    * **Cursor:** Deve ter um cursor de ponteiro (`cursor-pointer` no Tailwind).

2.  **Frase (`#fortune-message`):**
    * Um elemento de parágrafo (`<p>`) dentro do `#fortune-display`.
    * **Estado Inicial:** Deve estar oculto (ex: `opacity-0`, `h-0` ou `hidden` no Tailwind).
    * **Estado Final:** Deve se tornar visível (ex: `opacity-100`) com uma animação suave de *fade-in* (ex: `transition-opacity`, `duration-500` no Tailwind).

3.  **Botão "Pegar outro" (`#reset-button`):**
    * **Estado Inicial:** Oculto.
    * **Estado Final:** Deve aparecer *após* o biscoito ser aberto, permitindo ao usuário "resetar" a aplicação para pegar um novo biscoito.

## 5. Lógica de Interação (JavaScript)

O núcleo da aplicação será uma máquina de estados simples ("fechado" e "aberto").

1.  **Banco de Frases:**
    * Crie um array (constante) chamado `fortunes` contendo pelo menos 10 strings com frases de pensadores, poetas ou sábios.
    * *Exemplos:*
        * "A vida é 10% o que acontece com você e 90% como você reage a isso." - Charles R. Swindoll
        * "Seja a mudança que você deseja ver no mundo." - Mahatma Gandhi
        * "O único homem que não erra é aquele que nunca faz nada." - Theodore Roosevelt

2.  **Seleção de Elementos DOM:**
    * Obtenha referências para `#cookie-img`, `#fortune-message`, `#fortune-display`, e `#reset-button`.

3.  **Função `openCookie()`:**
    * Esta função deve ser chamada pelos eventos de interação.
    * Ela só deve executar se o biscoito estiver no estado "fechado".
    * **Ações:**
        1.  Selecionar uma frase aleatória do array `fortunes`.
        2.  Atualizar o `innerText` do `#fortune-message` com a frase.
        3.  Trocar o `src` do `#cookie-img` de `cookie-fechado.png` para `cookie-aberto.png`.
        4.  Tornar o `#fortune-display` (e a frase) visível (remover classes de ocultação).
        5.  Tornar o `#reset-button` visível.
        6.  Desativar os event listeners no biscoito para evitar cliques/hovers múltiplos.

4.  **Função `resetCookie()`:**
    * **Ações:**
        1.  Ocultar o `#fortune-display` e o `#reset-button`.
        2.  Trocar o `src` do `#cookie-img` de volta para `cookie-fechado.png`.
        3.  Reativar os event listeners de interação no biscoito.
        4.  Limpar o `innerText` do `#fortune-message`.

5.  **Event Listeners (Interação do Usuário):**
    * Aqui está a lógica crucial para atender aos requisitos de desktop e mobile:
    * Adicione um event listener de `click` ao `#cookie-img`. **Nota:** Embora o usuário tenha mencionado "passar o mouse" (hover) e "passar os dedos" (touch), um evento de `click` é a abordagem **mais prática e robusta** que funciona perfeitamente em *ambos* os cenários (mouse e toque), simplificando o código e garantindo a funcionalidade desejada.
    * Adicione um event listener de `click` ao `#reset-button` para chamar a função `resetCookie()`.

## 6. (Opcional) Implementação Fiel ao Hover/Touch

Se a IA *precisar* implementar a lógica exata de "hover" (desktop) e "touch" (mobile) em vez do `click` simplificado:

* **Detecção de Dispositivo:** Use uma verificação simples, como `window.matchMedia('(hover: hover)').matches`, para saber se é um dispositivo com capacidade de *hover*.
* **Desktop (com hover):** Adicione um listener `mouseenter` ao `#cookie-img` que chame `openCookie()`.
* **Mobile (sem hover):** Adicione um listener `touchstart` (ou `click`) ao `#cookie-img` que chame `openCookie()`.
* **Desafio:** O `mouseenter` (hover) não é uma ação "permanente". O usuário pode mover o mouse para fora. A lógica de `click` (item 5) é fortemente recomendada por ser mais prática e ter melhor UX. **Priorize a implementação do item 5 (baseada em `click`).**

## 7. Estrutura do `index.html` (Esqueleto)

```html
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Biscoitinhos da Sorte</title>
    <script src="[https://cdn.tailwindcss.com](https://cdn.tailwindcss.com)"></script>
    <style>
        /* Ex: Animação de fade-in para a frase */
        #fortune-display {
            transition: opacity 0.7s ease-in-out;
        }
    </style>
</head>
<body class="bg-gray-100 flex items-center justify-center h-screen font-sans">

    <main class="text-center p-6">
        
        <div id="cookie-wrapper" class="mb-6">
            <img id="cookie-img" 
                 src="URL_BISCOITO_FECHADO_PLACEHOLDER" 
                 alt="Biscoito da sorte fechado" 
                 class="w-48 h-48 md:w-64 md:h-64 cursor-pointer hover:scale-105 transition-transform duration-300">
        </div>

        <div id="fortune-display" 
             class="opacity-0 h-0 transition-all duration-700 ease-in-out">
            <div class="bg-white p-4 rounded-lg shadow-lg inline-block max-w-md">
                <p id="fortune-message" class="text-gray-700 text-lg italic">
                    </p>
            </div>
        </div>

        <button id="reset-button" 
                class="hidden mt-6 px-4 py-2 bg-blue-500 text-white rounded-lg shadow hover:bg-blue-600 transition-colors">
            Pegar outro biscoito
        </button>

    </main>

    <script>
        // Obter elementos
        const cookieImg = document.getElementById('cookie-img');
        const fortuneDisplay = document.getElementById('fortune-display');
        const fortuneMessage = document.getElementById('fortune-message');
        const resetButton = document.getElementById('reset-button');

        // URLs das Imagens (Substituir pelos assets reais)
        const closedCookieImg = '[https://via.placeholder.com/256/DDDDDD/808080?text=Biscoito+Fechado](https://via.placeholder.com/256/DDDDDD/808080?text=Biscoito+Fechado)';
        const openCookieImg = '[https://via.placeholder.com/256/DDDDDD/808080?text=Biscoito+Aberto](https://via.placeholder.com/256/DDDDDD/808080?text=Biscoito+Aberto)';
        
        // Placeholder das imagens reais (usar estes no código final)
        // const closedCookieImg = 'cookie-fechado.png';
        // const openCookieImg = 'cookie-aberto.png';

        // Banco de Frases
        const fortunes = [
            "A persistência é o caminho do êxito.",
            "Acredite em milagres, mas não dependa deles.",
            "O saber não ocupa lugar.",
            "A simplicidade é o último grau de sofisticação.",
            "Sorte é o que acontece quando a preparação encontra a oportunidade.",
            "Otimismo é esperar pelo melhor. Confiança é saber lidar com o pior.",
            "Seja a mudança que você deseja ver no mundo.",
            "A vida é uma jornada, não um destino.",
            "A paciência é amarga, mas seu fruto é doce.",
            "O conhecimento fala, mas a sabedoria escuta."
        ];

        let isCookieOpen = false;

        // Funções
        function openCookie() {
            if (isCookieOpen) return; // Só abre uma vez

            // 1. Escolher frase
            const randomIndex = Math.floor(Math.random() * fortunes.length);
            fortuneMessage.innerText = fortunes[randomIndex];

            // 2. Mudar imagem
            cookieImg.src = openCookieImg;
            cookieImg.alt = "Biscoito da sorte aberto";
            
            // 3. Mostrar frase (removendo classes de ocultação do Tailwind)
            fortuneDisplay.classList.remove('opacity-0', 'h-0');

            // 4. Mostrar botão de reset
            resetButton.classList.remove('hidden');

            // 5. Mudar estado
            isCookieOpen = true;
            cookieImg.classList.remove('cursor-pointer', 'hover:scale-105');
        }

        function resetCookie() {
            // 1. Ocultar frase e botão
            fortuneDisplay.classList.add('opacity-0', 'h-0');
            resetButton.classList.add('hidden');

            // 2. Resetar imagem
            cookieImg.src = closedCookieImg;
            cookieImg.alt = "Biscoito da sorte fechado";

            // 3. Resetar estado
            isCookieOpen = false;
            fortuneMessage.innerText = "";
            cookieImg.classList.add('cursor-pointer', 'hover:scale-105');
        }

        // Event Listeners
        cookieImg.addEventListener('click', openCookie);
        resetButton.addEventListener('click', resetCookie);
        
        // Configuração inicial da imagem (caso o placeholder não seja o padrão)
        cookieImg.src = closedCookieImg;
    </script>

</body>
</html>
```