def authenticated_actions actions
  @authenticated_actions = actions
end

def public_actions actions
  @public_actions = actions
end

def login
  @user = mock_model(User)
  @user_session = mock_model(UserSession, :user => @user)
  UserSession.stub!(:find).and_return @user_session
end

describe "a protected controller", :shared => true do
  @authenticated_actions ||= []
  @public_actions ||= []
  
  before(:each) do
    @actions = {
      :index => Proc.new { get :index },
      :create => Proc.new { post :create },
      :new => Proc.new { get :new },
      :show => Proc.new { get :show, :id => 1 },
      :update => Proc.new { put :update, :id => 1 },
      :edit => Proc.new { get :edit, :id => 1 },
      :destroy => Proc.new { delete :destroy, :id => 1}
    }
  end
  @authenticated_actions.each do |authenticated|
    describe "authenticated action #{authenticated}" do
      describe "when logged out" do
        it "redirects to login" do
          @actions[authenticated].call
          response.should redirect_to('/login')
        end
      end
      describe "when logged in" do
        before(:each) do
          login
        end
        it "does not redirect to login" do
          begin
            @actions[authenticated].call
          rescue ActiveRecord::RecordNotFound
          end
          response.should_not redirect_to('/login')
        end
      end
    end
  end
  @public_actions.each do |public|
    describe "public action #{public}" do
      it "does not redirect to login" do
        begin
          @actions[public].call
        rescue ActiveRecord::RecordNotFound
        end
        response.should_not redirect_to('/login')
      end
    end
  end
end

# describe "a protected controller", :shared => true do    
#   it "redirects to login" do
#     @action.call
#     response.should redirect_to('/login')
#   end
#   describe "as user" do
#     it "returns success response code" do
#       login
#       @action.call
#       response.response_code.should == @success
#     end
#   end
# end