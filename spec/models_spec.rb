describe Person do
  it "should have a name" do
    expect(Person.all.pluck(:name)).to include('Daniel', 'Bjorn')
  end

  it "should have pets" do
    pets = Person.find_by(name: 'Daniel').pets.map(&:name)
    expect(pets).to eq ['Shelby', 'Brownie']
  end
end
