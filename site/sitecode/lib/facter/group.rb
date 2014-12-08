Facter.add(:group) do

  setcode do
    hostname = Facter.value(:hostname)

    if hostname =~ /-|\d+/
      hostname.split(/\d+|-/).first
    else
      nil
    end
  end
end
