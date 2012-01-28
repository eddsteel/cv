require 'rake/clean'
require 'lib/document'
require 'rubygems'
begin
  require 'aws/s3'
rescue LoadError
  puts "AWS will not be available"
end

CLEAN << 'out'

directory 'out'

# Site for publishing
SITE="../edds-cloud"
PUBLIC="public"
SITE_PUBLIC= File.join SITE, PUBLIC
GIT_REMOTE="heroku"

##
# Set up files from templates
#
FileList['src/*'].each do |f|
  output = f.pathmap('%f')
  unless f =~ /\.partial\./ || f =~ /.yaml$/
    file f.pathmap('out/%f') => [f, 'out'] do |file|
      puts "template #{output}"
      File.open file.name, 'w' do |doc|
        doc.write Document.from_file(file.prerequisites[0]).result
      end
    end

    file output => f.pathmap('out/%f') do |f|
      sh "cp #{f.prerequisites[0]} #{f.name}"
    end

    CLOBBER << output
    task :default => output
    if f =~ /\.html$/
      task :"update-site" => output
    end
  end
end

##
# Set up PDF from tex files
#
# Each will be S3 pushable
#
FileList['src/*.tex'].each do |f|
  unless f =~ /\.partial\./ || f =~ /yaml$/
    file f.pathmap('%n.pdf') => f.pathmap('out/%f') do |file|
      sh "pdflatex -interaction batchmode #{f.pathmap('out/%f')}"
      sh "mv #{f.pathmap('%n')}.log out"
    end

    CLOBBER << f.pathmap('%n.pdf')

    desc 'Push CV to S3'
    task :push => f.pathmap('%n.pdf')
    task :default => f.pathmap('%n.pdf')
  end
end

task :"update-site" do |t|
  t.prerequisites.each do |f|
    if f=~ /html$/
      sh "cp #{f} #{SITE_PUBLIC}"
    end

    sh %Q|git --git-dir="#{SITE}/.git" --work-tree="#{SITE}" add #{File.join(PUBLIC, f.pathmap('%f'))}|
    sh %Q|git --git-dir="#{SITE}/.git" --work-tree="#{SITE}" commit -m 'Update documents'|
    sh %Q|git --git-dir="#{SITE}/.git" --work-tree="#{SITE}" push #{GIT_REMOTE}|

  end
end

task :push => [:"s3-connect", :"update-site"] do |t|
  t.prerequisites.each do |f|
    if f =~ /pdf$/
      puts "push #{f}"
      AWS::S3::S3Object.store f, open(f), 
        ENV['AMAZON_S3_BUCKET'], 
        :access => :public_read
    end
  end
end

task :"s3-connect" do
  AWS::S3::Base.establish_connection!(
    :access_key_id=>ENV['AMAZON_ACCESS_KEY_ID'],
    :secret_access_key=>ENV['AMAZON_SECRET_ACCESS_KEY'])
end
