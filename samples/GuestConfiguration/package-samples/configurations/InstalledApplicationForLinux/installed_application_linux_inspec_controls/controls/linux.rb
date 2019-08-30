val_packages = attribute('packages', description: 'The names of the packages that should be installed.')

control 'Installed Application Packages' do
  impact 1.0
  title 'Verify installed applications'
  desc 'Validates that application packages are installed'

  val_packages.each do |val_package|
    describe package(val_package) do
        it { should be_installed }
    end
  end
end