#!/usr/bin/env ruby
# vim: ft=ruby

require 'mechanize'

mechanize = Mechanize.new

# settings
login_page = 'http://login-page.com'
username_form_field = 'username'
password_form_field = 'password'

stored_hash_location = 'path/to/hash'
secrets_location = 'path/to/secrets'
navigation_path = [
    {text: 'Click me'},
    {text: 'And this Link...'}
]

# helper-functions
def read_file(file)
    file_content = ''
    File.open(file, "r") do |f|
        f.each_line do |line|
            file_content += line
        end
    end
    return file_content
end

def load_user_config(file)
    file_content = read_file(file)
    return JSON.parse(file_content)
end

# load user-config with credentials
config = load_user_config(secrets_location)
username = config['credentialsForMyPage']['username']
password = config['credentialsForMyPage']['password']

# login
page = mechanize.get(login_page)
# name of form for login
form = page.form_with(name: 'loginform')
form[username_form_field] = username
form[password_form_field] = password
page = form.submit

navigation_path.each do |path|
    link = page.link_with(path)  
    page = link.click
end

# get content of page
page_content = page.at('div.content').text

# hashing the content
hash = Digest::MD5.hexdigest(page_content).to_s
hash.chomp!
# get stored hash
stored_hash = read_file(stored_hash_location)
stored_hash.chomp!

# puts hash
if stored_hash == hash
    puts ''
else
    puts ''
end
