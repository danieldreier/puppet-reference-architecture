Facter.add(:is_valid_hostname) do
  # Determines if the short name follows the proper naming
  #
  # Right now, this only checks if the short name has the
  #   <application>-<function><number>-<appenv>
  # format. Eventually it will probably check that the values are allowed.
  #
  # Examples:
  #
  # FQDN - forge-web01-dev.ops.puppetlabs.net
  # Returns true
  #
  # FQDN - forge-webdev.ops.puppetlabs.net
  # Returns false
  #
  # FQDN - forge-web2-prod.ops.puppetlabs.net
  # Returns false

  setcode do
    hostname = Facter.value(:hostname)

    if hostname =~ /^([a-z]+)+-([a-z]+)(\d{2,})-([a-z]+)$/
      true
    else
      false
    end
  end
end
