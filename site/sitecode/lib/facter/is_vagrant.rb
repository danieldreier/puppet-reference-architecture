# Try and discover if this is a vagrant system
Facter.add(:is_vagrant) do
  confine :virtual => "virtualbox"

  setcode do
    %x{getent passwd vagrant}

    if $?.exitstatus == 0
      true
    else
      false
    end
  end
end

