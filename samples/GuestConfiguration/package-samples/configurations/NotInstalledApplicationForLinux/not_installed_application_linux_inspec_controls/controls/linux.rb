val_packages = attribute('packages', description: 'The names of the packages that should not be installed.')

control 'Not Installed Application Packages' do
  impact 1.0
  title 'Verify not installed applications'
  desc 'Validates that application packages are not installed'

  val_packages.each do |val_package|
    describe package(val_package) do
        it { should_not be_installed }
    end
  end
end