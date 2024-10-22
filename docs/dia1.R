#o comando install.packages() instala os pacotes necessários para rodar o código; caso já tenha instalado, não é necessário rodar novamente; então basta não executar as linhas com este comando ou deixá-las como comentário; um comentário no R é feito com o símbolo "#"; tudo que vem depois do "#" é ignorado pelo programa

install.packages("rvest")
install.packages("dplyr")
install.packages("stringr")

#após instalar os pacotes, é necessário carregá-los para que possam ser utilizados; isso é feito com o comando library():
library(rvest)
library(dplyr)
library(stringr)

#na primeira parte da aula, vamos aprender a extrair informações de uma página da web; para isso, vamos usar o pacote rvest; o primeiro passo é definir a URL da página que queremos extrair informações; neste caso, vamos usar a página do site NSC Total que fala sobre os 20 melhores filmes de todos os tempos até 2020

url <- "https://www.nsctotal.com.br/noticias/20-melhores-filmes-todos-os-tempos-ate-2020" #definindo a URL

html <- read_html(url) #lendo o conteúdo da página; agora todo o html da página está armazenado na variável html
html #exibindo o conteúdo da variável html; observe que o html da página agora está no R e podemos manipulá-lo!

html_elements(html,"h2") #a função html_elements() extrai os elementos html da página; neste caso, estamos extraindo os elementos h2 da página; observe que o R exibe os elementos h2 da página

#a execução acima poderia ser feita utilizando o operador pipe; o operador pipe é representado por |> e serve para encadear funções; ele é muito útil para deixar o código mais limpo e legível; o código abaixo faz a mesma coisa que o código acima, mas de forma mais limpa e legível
html |>
  html_elements("h2") #o operador pipe encadeia as funções; o resultado da função html é passado como argumento para a função html_elements()

#a seguir, vamos extrair o texto dos elementos h2 da página com a classe wp-block-heading; lembre-se que uma classe deve ser precedida por um ponto; depois, vamos extrair o texto que está dentro desses elementos e salvar na variável titulos
titulos <-html |>
  html_elements("h2.wp-block-heading")|>
  html_text2()

#percebemos que o resultado da raspagem possui entradas que não são títulos de filmes; vamos apenas considerar as posições que são filmes; estas entradas estão nas posições 2 a 21; então vamos salvar apenas essas posições na variável titulos_1
titulos_1 <- titulos[2:21]
titulos_1

#por fim, vamos limpar os títulos; para isso, vamos remover o texto que precede os títulos; o texto que precede os títulos é um número seguido de um traço e um espaço; vamos remover esse texto com a função str_remove(); o resultado será salvo na variável titulos_limpo; primeiros, estes elementos que queremos eliminar estão no início de cada string, então vamos usar "^" para indicar que queremos remover do início da string; em seguida, vamos usar "\\d+" para indicar que queremos remover um ou mais dígitos (1,2 ou 11, 13, etc); depois, vamos usar "\\s" para indicar que queremos remover um espaço; por fim, vamos usar "." para indicar que queremos remover qualquer caractere, que no nosso caso será um traço; o código abaixo faz isso:
titulos_limpo <- titulos_1 |>
  str_remove("^\\d+\\s.\\s") 


#chegamos à segunda parte da aula; agora vamos extrair informações de uma tabela; para isso, vamos usar uma página da Wikipédia que fala sobre a alfabetização nas unidades federativas do Brasil; a URL da página é a seguinte:
url <- "https://pt.wikipedia.org/wiki/Lista_de_unidades_federativas_do_Brasil_por_alfabetiza%C3%A7%C3%A3o#:~:text=A%20unidade%20federativa%20com%20o,Para%C3%ADba%20(86%2C8%25)"

#vamos ler o conteúdo da página e armazenar na variável html
html<- read_html(url)
html

#percebemos após uma inspeção no código fonte da página que a tabela que queremos extrair está dentro de um elemento com a classe wikitable; vamos extrair essa tabela e salvar na variável tabela; a função html_elements() extrai os elementos html da página; neste caso, estamos extraindo os elementos com a classe wikitable; depois, a função html_table() extrai a tabela desses elementos; o resultado é salvo na variável tabela
tabela<- html |>
  html_elements("table.wikitable")|>
  html_table()

#o resultado da raspagem é uma lista com duas tabelas; vamos salvar a primeira tabela na variável tabela1 e a segunda tabela na variável tabela2; e agora podemos manipular essas tabelas como quisermos.
tabela1<- tabela[[1]]
tabela2<- tabela[[2]]

#durante a aula, deixamos um exercício que consistia em raspar os títulos da seção de economia da cnn; a resposta está abaixo:

url <- "https://www.cnnbrasil.com.br/economia/"
html <- read_html(url)

html |>
  html_elements("h3.block__news__title") |>
  html_text2()

#outro exercício era remover os anos dos títulos dos filmes; a resposta está abaixo:

titulos_finais <- titulos_limpo |>
  str_remove("\\s.\\d+.") #aqui estamos usando . para indicar que queremos remover qualquer caractere, que no nosso caso é um parenteses; um parenteses representa outras coisas em expressões regulares e, portanto, não podemos usar ( ou ) diretamente; mas observe que como o ponto significa qualquer caractere, ele também remove o parenteses e assim a expressão "\\s.\\d+." consegue remover uma sequência de espaço,parenteses, um ou mais dígitos e outro parenteses, exemplo," (2008)".