Facter.add(:function) do
  # Provides the function for the server. Only works if the short name
  # follows the proper naming conventions, otherwise returns nil.
  #
  # Example:
  #
  # FQDN - forge-web01-dev.ops.puppetlabs.net
  # function - web

  setcode do
    if Facter.value(:is_valid_hostname)
      hostname = Facter.value(:hostname)

      if /^(?<application>[a-z]+)+-(?<function>[a-z]+)(?<function_number>\d{2,})-(?<appenv>[a-z]+)$/ =~ hostname
        function
      else
        nil
      end
    end
  end
end
