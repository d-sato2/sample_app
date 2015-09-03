require 'spec_helper'

describe "Static pages" do

  #let(:base_title){"Ruby on Rails Tutorial Sample App"}
  subject{ page } 

  #-----冗長を排除するための機能:shared_examples-----
  shared_examples_for "all static pages" do
    it{should have_content(heading)}
    it{should have_title(full_title(page_title))}
  end


  #-----Homeページ-----
  describe "Home page" do 
    before{visit root_path}

    let(:heading) {'Sample App'}
    let(:page_title) {''}

    it_should_behave_like "all static pages"
    it {should_not have_title('| Home')}

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem")
        FactoryGirl.create(:micropost, user: user, content: "Ipsum")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 followers", href: followers_user_path(user)) }
      end
    end
  end

  #-----Helpページ-----
  describe "Help page" do
    before{visit help_path}

    let(:heading) {'Help'}
    let(:page_title) {'Help'}
  end

  #-----Aboutページ-----
  describe "About page" do
    before{visit about_path}

    let(:heading) {'About Us'}
    let(:page_title) {'About Us'}
  end

 #-----Contactページ----- 
  describe "Contact page" do
    before{visit contact_path}

    let(:heading) {'Contact'}
    let(:page_title) {'Contact'}
  end

  #-----レイアウトのリンクのテスト-----
  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "Home"
    click_link "Sign up now!"
    expect(page).to have_title(full_title('Sign up'))
    click_link "sample app"
    expect(page).to have_title(full_title(''))
  end
end