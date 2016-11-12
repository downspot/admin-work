require 'spec_helper'
describe 'volume_attach' do

  context 'with defaults for all parameters' do
    it { should contain_class('volume_attach') }
  end
end
