require 'spec_helper'

describe Dotman::Collect do

  let(:collect) { Dotman::Collect.new }

  before :each do
    Dotman::Notification.stub(:collecting)
    Dotman::Notification.stub(:copying_to_dotfiles)
  end

  context '#create_dotman' do

    it 'should check for dotfiles directory and not create if exists' do
      File.stub(:directory?).and_return(true)
      FileUtils.should_not_receive(:mkdir)
      collect.create_dotman
    end
    
    it 'should check for dotfiles directory and create if does not exist' do
      File.stub(:directory?).and_return(false)
      FileUtils.should_receive(:mkdir)
      collect.create_dotman
    end

    it 'should call collect_dotfiles to continue execution' do
      File.stub(:directory?).and_return(true)
      collect.should_receive(:collect_dotfiles)
      collect.create_dotman 
    end

  end

  context '#collect_dotfiles' do

    it 'should call copy_over_dot for each dotfile in pwd' do
      Dir.stub(:entries).and_return(['test1', 'test2', 'test3'])
      collect.should_receive(:copy_over_dot).exactly(3).times
      collect.collect_dotfiles
    end

    it 'should print collecting for script status' do
      collect.stub(:copy_over_dot)
      Dotman::Notification.should_receive(:collecting)
      collect.collect_dotfiles
    end
  end

  context '#copy_over_dot' do

    it 'should copy dot files over if correct file format' do
      FileUtils.should_receive(:copy).exactly(1).times
      collect.copy_over_dot(File.join(ENV['HOME'], '.dotman'))
    end

    it 'should print out file being copied for user' do
      Dotman::Notification.should_receive(:copying_to_dotfiles).with("#{File.join(ENV['HOME'], '.dotman')}")
      FileUtils.stub(:copy)
      collect.copy_over_dot(File.join(ENV['HOME'], '.dotman'))
    end

  end

end
