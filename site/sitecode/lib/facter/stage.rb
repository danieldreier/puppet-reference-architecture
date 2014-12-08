Facter.add(:stage) do

  setcode do
    hostname = Facter.value(:hostname)

    if hostname =~ /-/
      hostname.split('-').last
    else
      nil
    end
  end
end
