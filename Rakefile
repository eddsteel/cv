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

FileList['src/*'].each do |f|
  output = f.pathmap('%f')
  unless f =~ /\.partial\./ || f =~ /.yaml$/
    file f.pathmap('out/%f') => [f, 'out'] do |file|
      File.open file.name, 'w' do |doc|
        doc.write Document.from_file(file.prerequisites[0]).result
      end
    end

    file output => f.pathmap('out/%f') do |f|
      sh "cp #{f.prerequisites[0]} #{f.name}"
    end

    CLOBBER << output
    task :default => output
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

task :push => [:"s3-connect"] do |t|
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
