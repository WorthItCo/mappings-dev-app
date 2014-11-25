require 'pry'
require 'bundler'
Bundler.setup
require 'sinatra'
require 'active_support'
require 'active_support/core_ext'

require 'worth_it_mapping'

before do
   content_type :json    
   headers 'Access-Control-Allow-Origin' => '*', 
            'Access-Control-Allow-Methods' => ['OPTIONS', 'GET', 'POST']  
end

get '/' do
  bookmarklet = 'javascript:((function()%7Bvar%20t,e,s,i,n%0At=function()%7Bfunction%20t(t,e,s)%7Bfor(this.id=t,this.script=e,this.style=s;null!==this.find(this.id);)this.remove(this.find(this.id))%0Anull===this.find(this.id)&&this.add()%7Dreturn%20t.prototype.find=function()%7Breturn%20document.getElementById(this.id)%7D,t.prototype.remove=function()%7Breturn%20document.body.removeChild(this.find(this.id))%7D,t.prototype.add=function()%7Bvar%20t,e,s%0Areturn%20t=document.createElement(%22div%22),t.id=this.id,t.setAttribute(%22data-auth-token%22,%22saYov45aJve4LP6cqqKi%22),null!==this.script&&(e=document.createElement(%22script%22),e.type=%22text/javascript%22,e.charset=%22UTF-8%22,e.src=this.script,t.appendChild(e)),null!==this.style&&(s=document.createElement(%22link%22),s.href=this.style,s.rel=%22stylesheet%22,s.type=%22text/css%22,t.appendChild(s)),document.body.appendChild(t)%7D,t%7D(),s=%221.8.0%22,null==window.jQuery%7C%7Cwindow.jQuery.fn.jquery%3Cs?(e=!1,n=document.createElement(%22script%22),n.src=%22http://ajax.googleapis.com/ajax/libs/jquery/%22+s+%22/jquery.min.js%22,n.onload=n.onreadystatechange=function()%7Bvar%20s%0Areturn%20e%7C%7Cthis.readyState&&%22loaded%22!==this.readyState&&%22complete%22!==this.readyState?void%200:(e=!0,s=new%20t(%22worthit%22,%22http://localhost:4567/assets/bookmarklet.js%22,%22http://localhost:4567/assets/bookmarklet.css%22))%7D,document.getElementsByTagName(%22head%22)[0].appendChild(n)):i=new%20t(%22worthit%22,%22http://localhost:4567/assets/bookmarklet.js%22,%22http://localhost:4567/assets/bookmarklet.css%22)%7D).call(this)%0A);'
  content_type :html
  "Drag this link to your bookmarklet bar to develop on the WorthIt Mappings: <a href='#{bookmarklet}''>WorthItDev</a>"
end

get '/api/mappings/*' do
  params[:url] = params[:splat].first
  hash = {
 #   { 
      mapping: mapping
#    }, callback: params[:callback]
  }

  hash.to_json
end

options '/assets/mapping/*' do
  200
end

get '/assets/mappings/*' do
  content_type :js
  file = params[:splat].first
  headers("Access-Control-Allow-Origin" =>  "*")
  WorthItMapping.for_site(file.gsub('.js', ''))
end

def mapping
  @mapping ||= get_mapping URI.decode(params[:url])
end

def get_mapping(path)
  my_path = path.gsub(/(^http:[\/])([^\/])/i) { "#{$1}/#{$2}" }
  my_path = my_path.gsub(/(^https:[\/])([^\/])/i) { "#{$1}/#{$2}" }

  if WorthItMapping.has_mapping_for?(my_path)
    uri = URI.parse('http://localhost:4567')
    uri.merge(WorthItMapping.path_for_site(my_path)).to_s
  end
end