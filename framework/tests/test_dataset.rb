require 'minitest/autorun'
require '../dataflow/dataset'

describe ScriniumEsmDiag::Dataset do
  before do
    @dataset = ScriniumEsmDiag::Dataset.new
  end

  describe 'root attribute' do
    it 'sets @root instance variable only once' do
      @dataset.root = '/foo/bar'
      @dataset.root.must_equal '/foo/bar'
    end
  end

  describe 'pattern attribute' do
    it 'sets @pattern instance variable only once' do
      @dataset.pattern = 'foo.*.nc'
      @dataset.pattern.must_equal 'foo.*.nc'
    end
  end

  describe 'requires method' do
    it 'sets @variables' do
      @dataset.requires :U, :V, :T, :Q
      @dataset.variables.size.must_equal 4
      @dataset.variables.keys.must_equal [ :U, :V, :T, :Q ]
      [ :U, :V, :T, :Q ].each do |x|
        @dataset.variables[x].class.must_equal Hash
        @dataset.variables[x].size.must_equal 0
      end
    end
  end

  describe 'extract method' do
    it 'sets @variables' do
      @dataset.extract :A, :B
      @dataset.variables.size.must_equal 2
      @dataset.variables[:A].class.must_equal Hash
      @dataset.variables[:A][:extract].class.must_equal Hash
      @dataset.variables[:A][:extract].must_be_empty
      @dataset.variables[:B][:extract].class.must_equal Hash
      @dataset.variables[:B][:extract].must_be_empty
    end
  end

  describe 'vinterp method' do
    it 'sets vinterp item for given variables in @variables' do
      @dataset.vinterp :A, :B, :option => :is_here
      @dataset.variables.size.must_equal 2
      @dataset.variables[:A].class.must_equal Hash
      @dataset.variables[:A][:vinterp].class.must_equal Hash
      @dataset.variables[:A][:vinterp].must_equal :option => :is_here
      @dataset.variables[:B].class.must_equal Hash
      @dataset.variables[:B][:vinterp].class.must_equal Hash
      @dataset.variables[:B][:vinterp].must_equal :option => :is_here
    end

    it 'raise error when no variable is required and :all is given' do
      error = -> { @dataset.vinterp :all, :option => :is_here }.must_raise RuntimeError
      error.message.must_equal 'no variable is required yet!'
    end

    it 'sets vinterp item for all variables in @variables' do
      @dataset.requires :A, :B
      @dataset.vinterp :all, :option => :is_here
      @dataset.variables.size.must_equal 2
      @dataset.variables[:A].class.must_equal Hash
      @dataset.variables[:A][:vinterp].class.must_equal Hash
      @dataset.variables[:A][:vinterp].must_equal :option => :is_here
      @dataset.variables[:B].class.must_equal Hash
      @dataset.variables[:B][:vinterp].class.must_equal Hash
      @dataset.variables[:B][:vinterp].must_equal :option => :is_here
    end
  end

  describe 'filter method' do
    it 'sets filter item for given variable in @variables' do
      @dataset.filter :A, :B, :option => :is_here
      @dataset.variables.size.must_equal 2
      @dataset.variables[:A].class.must_equal Hash
      @dataset.variables[:A][:filter].class.must_equal Hash
      @dataset.variables[:A][:filter].must_equal :option => :is_here
      @dataset.variables[:B].class.must_equal Hash
      @dataset.variables[:B][:filter].class.must_equal Hash
      @dataset.variables[:B][:filter].must_equal :option => :is_here
    end

    it 'raise error when no variable is required and :all is given' do
      error = -> { @dataset.filter :all, :option => :is_here }.must_raise RuntimeError
      error.message.must_equal 'no variable is required yet!'
    end

    it 'sets filter item for all variables in @variables' do
      @dataset.requires :A, :B
      @dataset.filter :all, :option => :is_here
      @dataset.variables.size.must_equal 2
      @dataset.variables[:A].class.must_equal Hash
      @dataset.variables[:A][:filter].class.must_equal Hash
      @dataset.variables[:A][:filter].must_equal :option => :is_here
      @dataset.variables[:B].class.must_equal Hash
      @dataset.variables[:B][:filter].class.must_equal Hash
      @dataset.variables[:B][:filter].must_equal :option => :is_here
    end
  end

  describe 'anomaly method' do
    it 'sets anomaly item for given variables in @variables' do
      @dataset.anomaly :A, :B
      @dataset.variables.size.must_equal 2
      @dataset.variables[:A].class.must_equal Hash
      @dataset.variables[:A][:anomaly].must_be_empty
      @dataset.variables[:B][:anomaly].must_be_empty
    end

    it 'raise error when no variable is required and :all is given' do
      error = -> { @dataset.anomaly :all }.must_raise RuntimeError
      error.message.must_equal 'no variable is required yet!'
    end

    it 'sets anomaly item for all variables in @variables' do
      @dataset.requires :A, :B
      @dataset.anomaly :all
      @dataset.variables.size.must_equal 2
      @dataset.variables[:A].class.must_equal Hash
      @dataset.variables[:A][:anomaly].must_be_empty
      @dataset.variables[:B][:anomaly].must_be_empty
    end
  end

  describe 'detour method' do
  end
end
