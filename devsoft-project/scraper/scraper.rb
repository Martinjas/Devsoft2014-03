# encoding:utf-8
require 'json'
require 'mechanize'
require 'rubygems'
################################################
##           !USE YOUR CREDENTIALS            ##
################################################
USERNAME = 'aluno' # Use your username!
PASSWORD = '12345' # Use your password!

#
# Helper function that saves a HTML file on the html directory.
#
# @param [String] filename the name of the file to be saved.
# @param [String] body the body of the HTML file.
#
def save_html(filename, body)
  File.open("saved_html/#{filename}.html", "w") do |f|
    f.write(body.force_encoding('utf-8'))
  end
end

mechanize = Mechanize.new
mechanize.user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.131 Safari/537.36"

mechanize.get('http://estagios.pcs.usp.br/')
mechanize.get('http://estagios.pcs.usp.br/semLogin/login.aspx')

save_html('before_login', mechanize.page.body)

form = mechanize.page.forms[0]

headers = {
  'Host' => 'estagios.pcs.usp.br',
  'Connection'      => 'keep-alive',
  'Cache-Control'   => 'max-age=0',
  'Accept'          => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
  'Origin'          => 'http://estagios.pcs.usp.br',
  'Content-Type'    => 'application/x-www-form-urlencoded',
  'Referer'         => 'http://estagios.pcs.usp.br/semLogin/login.aspx',
  'Accept-Encoding' => 'gzip,deflate,sdch',
  'Accept-Language' => 'en-US,en;q=0.8,pt;q=0.6,de;q=0.4'
}

params = {
  '__EVENTTARGET'     => '',
  '__EVENTARGUMENT'   => '',
  '__VIEWSTATE'       => form.field_with(name: '__VIEWSTATE').value,
  '__EVENTVALIDATION' => form.field_with(name: '__EVENTVALIDATION').value,
  'ctl00$ContentPlaceHolder1$Login1$UserName'    => USERNAME,
  'ctl00$ContentPlaceHolder1$Login1$Password'    => PASSWORD,
  'ctl00$ContentPlaceHolder1$Login1$LoginButton' => 'Logar'
}

mechanize.post("http://estagios.pcs.usp.br/semLogin/login.aspx", params, headers)

save_html('after_login', mechanize.page.body)

################################################
##         TODO: CONTINUE FROM HERE!          ##
################################################

page = mechanize.page.links.find { |l| l.text == "Vagas disponíveis" }.click


save_html('vagas disponiveis',mechanize.page.body)
links =page.links_with(:href => /exibirVaga/)
a=0
vacationes = Hash.new
vaga=Hash.new
vagas=[]
ntotal=0
links.each do |l|		
	pagina = mechanize.click(l)
	vaga=Hash.new
	vaga[:Area]= pagina.search(%Q{span[@id='ContentPlaceHolder1_lblArea']}).text
	vaga[:Titulo]=pagina.search(%Q{span[@id='ContentPlaceHolder1_lblTitulo']}).text
	vaga[:Empresa]=pagina.search(%Q{span[@id='ContentPlaceHolder1_lblEmpresa']}).text
	vaga[:Descricao]=pagina.search(%Q{span[@id='ContentPlaceHolder1_lblDescricao']}).text
	vaga[:Requisitos]=pagina.search(%Q{span[@id='ContentPlaceHolder1_lblRequisitos']}).text	
	vaga[:Beneficios]=pagina.search(%Q{span[@id='ContentPlaceHolder1_lblBeneficios']}).text	
	vaga[:NumerodeVagas]=pagina.search(%Q{span[@id='ContentPlaceHolder1_lblNumeroVagas']}).text
	vagas<<vaga
	ntotal+=vagas[a][:NumerodeVagas].to_i	
	puts vagas[a][:Empresa]
	save_html("vaga nbm= #{a}",pagina.body)
	a=a+1
		
end

vagas.each do |s| 
	puts s[:Area]
end
File.open("data.json","w") do |f|
	f.write(vagas.to_json)
end
