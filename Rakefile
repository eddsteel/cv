require 'rake/clean'
require 'rubygems'
require 'aws/s3'

CV = 'cv.tex'
CV_OUT = CV.ext('.pdf')
CLEAN << FileList['*.dvi'] + FileList['*.log']
CLOBBER << CV.ext('pdf')
BUCKET = 'eddscloud-public'

desc 'Build CV'
file CV_OUT => CV do
  sh "pdflatex #{CV}"
end

task :"s3-connect" do
  AWS::S3::Base.establish_connection!(
    :access_key_id=>ENV['AMAZON_ACCESS_KEY_ID'],
    :secret_access_key=>ENV['AMAZON_SECRET_ACCESS_KEY'])
end

desc 'Push CV to S3'
task :push => [CV_OUT, :"s3-connect"] do
  AWS::S3::S3Object.store CV_OUT, open(CV_OUT),
    BUCKET, :access => :public_read
end

task :spec do
  ruby 'spec/*'
end

task :gem => [:spec] do
  gem '*.gemspec'
end

task :default => CV_OUT

