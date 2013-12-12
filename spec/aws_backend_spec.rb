require "hiera/backend/aws_backend"

class Hiera
  module Backend
    describe Aws_backend do
      let(:backend) { Aws_backend.new }
      let(:lookup_key) { "some_key" }
      let(:lookup_scope) { { "foo" => "bar" } }
      let(:lookup_params) { [lookup_key, lookup_scope, "", :priority] }

      before do
        Hiera.stub(:debug)
      end

      it "returns nil if hierarchy is empty" do
        Backend.stub(:datasources)
        expect(backend.lookup(*lookup_params)).to be_nil
      end

      it "returns nil if service is unknown" do
        Backend.stub(:datasources).and_yield "aws/unknown_service"
        expect(backend.lookup(*lookup_params)).to be_nil
      end

      it "properly forwards lookup to ElastiCache service" do
        Backend.stub(:datasources).and_yield "aws/elasticache"
        Aws::ElastiCache.any_instance.should_receive(:lookup).
          with(lookup_key, lookup_scope)
        backend.lookup(*lookup_params)
      end
    end
  end
end