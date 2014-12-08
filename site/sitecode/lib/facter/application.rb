Facter.add(:application) do
  # Provides the application label for the server. Only works if the
  # short name follows the proper naming conventions, otherwise
  # returns nil.
  # https://confluence.puppetlabs.com/display/OPS/Naming+Standards
  #
  # Example:
  #
  # FQDN - forge-web01-dev.ops.puppetlabs.net
  # application - forge

  setcode do
    if Facter.value(:is_valid_hostname)
      hostname = Facter.value(:hostname)

      hostname.split('-').first
    else
      nil
    end
  end
end
