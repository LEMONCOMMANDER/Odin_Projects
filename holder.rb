require 'spec_helper'

#NOTE: ALL UI HAS "WORKSPACE" READ "DATA ROOM"
# HTML/CSS ELEMENTS STILL REFER TO "WORKSPACE"

def set_account_default_dataroom
  visit edit_account_theme_path
  select 'Data Room', from: 'account_default_workspace_mode'
  expect(page).to have_selector('div.text-pairing', text: 'Your default data room mode was successfully saved.')

  sleep(1)
  page.refresh

  expect(page).to have_selector('select#account_default_workspace_mode option[selected]', text: 'Data Room')
end

def create_dataroom(name)
  find('div.create_workspace').click
  within 'form#workspace_form' do
    find('input#workspace_name').set("#{name}")
    find('button').click
  end

  expect(current_url).to include("/workspaces/")
  expect(page).to have_selector('h1', text: "#{name}")
end

def create_folder(name)
  find('a#create_picker').click
  find('a#create_folder').click
  within 'div.ui-tooltip-focus' do
    find('input#folder_filename').set(name)
    sleep(1)
    find('button', text: 'Create').click
  end
end


describe 'DATA ROOM TESTS', type: :system, local: true do
  include DownloadHelpers

  let (:user) { users(:tesla) }
  let (:dataroom) {workspaces(:tesla_workspace_dr)}
  let (:sfs) {workspaces(:tesla_workspace)}
  let (:account) {user.account}

  xscenario 'test' do
    dataroom.setup_first_run
    selenium_signin(user.email, 'atest', workspace_path(dataroom))
    allow($rollout).to receive(:active?).with('account:file_indexing_disabled', account).and_return(false)
    5.times do |i|
      create_folder("test#{i}")
      find('li.item.folder div.title', text: "test#{i}")
    end

    find('li#options').click
    within 'div.ui-tooltip-focus' do
      find('input#workspace_file_indexing').click
      sleep(1)
      find('button#save').click
    end

    sleep(3)
    # visit home_path
    # find('li.workspace.home-item div.title', text: dataroom.name).click
    page.refresh

    within 'main#files' do
      expect(all('li.item').count).to eq(6)
      all('li.item').each_with_index do |item, index|
        expect(item.find('div.title').text).to start_with("#{index + 1} ")
      end
    end
  end

  context "[home page tests]" do
    before(:each) do
      # NOTE - having an item in the dataroom populates it on the home page... without this, the data room will not show up without some UI nonsense
      # there may be a better way to do this, but it's a safe way to ensure the data room is present for now
      dataroom.setup_first_run
      selenium_signin(user.email, 'atest')
    end


    scenario 'when the account settings set to <data room mode>, create a data room in <data room mode>', testrail_id: 24_454 do
      set_account_default_dataroom
      sleep(1)

      visit home_path
      starting_count = all('li.workspace.home-item').count
      create_dataroom('New Data Room')

      expect(page).to have_selector('div.text-pairing', text:  "Welcome to your new data room!")

      find('li#options').click
      within 'div.ui-tooltip-focus' do
        expect(page).to have_select('workspace_data_room', selected: 'Data Room')
      end

      visit home_path
      expect(all('li.workspace.home-item').count).to eq(starting_count + 1)
    end


    #note in here
    scenario 'find a data room(s) through the home page filter box', testrail_id: 24_455 do
      #TODO: filter doesn't play well with populated data rooms: "Tesla Workspace", "Tesla Workspace 1", and "Tesla Workspace 2"
      # i am not sure why this behavior is happening... i will create new data rooms in the test as a workaround -- find out why

      5.times do |i|
        case i
        when 0 then create_workspace("something to search")
        when 1 then create_workspace("the first step of knowing is searching")
        when 2 then create_workspace("Searching is kind of like seeking")
        when 3 then create_workspace("we are searching for the truth!")
        when 4 then create_workspace("you won't find me by sea-rching")
        end
        visit home_path
      end

      expect(all('li.workspace.home-item').count).to eq(10)
      expect(page).to have_selector('li.workspace.home-item div.title', text: "you won't find me by sea-rching")

      find('section.data-rooms.page').find('input#home-query').set('search')
      sleep(3)
      expect(all('li.workspace.home-item').count).to eq(4)
      all('li.workspace.home-item div.title').each do |dr|
        expect(dr.text.downcase).to include("search")
      end

      page.refresh

      find('section.data-rooms.page').find('input#home-query').set('dr')
      sleep(3)
      expect(page).to have_selector('li.workspace.home-item div.title', text: dataroom.name)
      expect(all('li.workspace.home-item').count).to eq(1)
    end


    context '[inviting users from the home page]' do
      #joe@joe.com is a user that has access to resources on the tesla account
      scenario 'a user is invited with specific permissions' do
        selected_dataroom = find('li.workspace.home-item div.title', text: dataroom.name).ancestor('li.workspace.home-item')
        selected_dataroom.find('li.collaborators').click

        within 'div.ui-tooltip-focus' do
          find('button', text: "Invite Users").click
          expect(page).to have_selector('div.share_form.drawer', visible: true)

          find('textarea#invitation_emails').set('joe@joe.com')
          find('select#invitation_role_id').select('Printer') # downloader > printer
          sleep(1)
          find('button', text: /Invite\z/).click

          invited_user = find('li.item.user div.name', text: 'joseph joe').ancestor('li.item.user')
          expect(invited_user).to have_select('rolemap_role', selected: 'Printer')
        end
      end


      scenario 'a user without access to an account resource will have the "invited" chip', testrail_id: 24_457 do
        selected_dataroom = find('li.workspace.home-item div.title', text: dataroom.name).ancestor('li.workspace.home-item')
        selected_dataroom.find('li.collaborators').click

        within 'div.ui-tooltip-focus' do
          find('button', text: "Invite Users").click
          expect(page).to have_selector('div.share_form.drawer', visible: true)

          find('textarea#invitation_emails').set('fake@test.com')
          sleep(1)
          find('button', text: /Invite\z/).click

          invited_user = find('li.item.user div.name', text: 'fake@test.com').ancestor('li.item.user')
          expect(invited_user).to have_selector('a.chip.invited')
        end
      end


      #testrail needed
      scenario 'a user with existing access to a resource on the account will have their data room invite be auto accepted' do
        selected_dataroom = find('li.workspace.home-item div.title', text: dataroom.name).ancestor('li.workspace.home-item')
        selected_dataroom.find('li.collaborators').click

        within 'div.ui-tooltip-focus' do
          find('button', text: "Invite Users").click
          expect(page).to have_selector('div.share_form.drawer', visible: true)

          find('textarea#invitation_emails').set('joe@joe.com')
          sleep(1)
          find('button', text: /Invite\z/).click

          expect(page).to have_selector('li.item.user div.name', text: 'joseph joe')
        end
      end
    end # home page / inviting users


    scenario "invites a group to a data room from the home page" do
      selenium_signout

      #tw_creator_group verify existing permissions: email = "tw_creator_group_member@user.com"
      selenium_signin("tw_creator_group_member@user.com", 'atest')
      expect(all('li.workspace.home-item').count).to eq(1) #only has access to tesla_workspace
      selenium_signout

      # add "tesla account group" to tesla_workspace_dr
      selenium_signin(user.email, 'atest')
      selected_dataroom = find('li.workspace.home-item div.title', text: dataroom.name).ancestor('li.workspace.home-item')
      selected_dataroom.find('li.collaborators').click
      within 'div.ui-tooltip-focus' do
        find('a#groups').click
        expect(find('div.footer').text).to include('This data room can be accessed by 0 of 3 Groups')

        selected_group = find('li.group-item div.name', text: /Tesla Account Group\z/).ancestor('li.group-item')
        sleep(1)
        selected_group.find('select#role_id').select("Downloader")
        expect(selected_group).to have_selector('li.js-preview-link', visible: true)
        expect(find('div.footer').text).to include('This data room can be accessed by 1 of 3 Groups')
        close_modal
      end
      selenium_signout

      #tw_creator_group verify access to tesla_workspace_dr
      selenium_signin("tw_creator_group_member@user.com", 'atest')
      expect(all('li.workspace.home-item').count).to eq(2) #only has access to tesla_workspace
      expect(page).to have_selector('li.workspace.home-item div.title', text: dataroom.name)
    end


    #todo - scenario to add restore notification
    context '[archiving data rooms]' do
      scenario 'archives a data room', testrail_id: 24_470 do
        expect(page).not_to have_selector('div.scope.js-archive-form', wait: 3)
        selected_dataroom = find('li.workspace.home-item div.title', text: dataroom.name).ancestor('li.workspace.home-item')
        selected_dataroom.hover.find('li[oldtitle="Archive Data Room"]').click
        sleep(1)

        within 'div.ui-tooltip-focus' do
          find('a.button.ok').click
        end

        expect(page).to have_selector('div.scope.js-archive-form')
        archived_dataroom = find('li.workspace.home-item div.chip.disabled', text: "ARCHIVED")
        expect(archived_dataroom.ancestor('li.workspace.home-item')).to have_selector('div.title', text: dataroom.name)
      end


      #testrail needed
      scenario 'an archived data room can not be seen by non admin users' do
        #viewer user has account access as a viewer and can view all non-archived data rooms
        # id: 695452740
        # email: "viewer_user@user.com"

        selected_dataroom = find('li.workspace.home-item div.title', text: dataroom.name).ancestor('li.workspace.home-item')
        selected_dataroom.hover.find('li[oldtitle="Archive Data Room"]').click
        sleep(1)

        within 'div.ui-tooltip-focus' do
          find('a.button.ok').click
        end

        archived_dataroom = find('li.workspace.home-item div.chip.disabled', text: "ARCHIVED")
        expect(archived_dataroom.ancestor('li.workspace.home-item')).to have_selector('div.title', text: dataroom.name)
        selenium_signout

        #checks that viewer user can't see the data room when arvhived
        selenium_signin("viewer_user@user.com", 'atest')
        expect(page).not_to have_selector('li.workspace.home-item div.title', text: dataroom.name, wait: 3)
      end


      scenario 'show / hide an archived data room', testrail_id: 24_471 do
        #archives the data room
        selected_dataroom = find('li.workspace.home-item div.title', text: dataroom.name).ancestor('li.workspace.home-item')
        selected_dataroom.hover.find('li[oldtitle="Archive Data Room"]').click
        sleep(1)

        within 'div.ui-tooltip-focus' do
          find('a.button.ok').click
        end
        expect(all('li.workspace.home-item div.chip.disabled', text: "ARCHIVED").count).to eq(1)

        page.refresh

        #archives start hidden
        expect(page).not_to have_selector('li.workspace.home-item div.title', text: dataroom.name, wait: 3)
        expect(all('li.workspace.home-item div.chip.disabled', text: "ARCHIVED").count).to eq(0)

        #shows archived workspace
        find('input#show_archived').click
        expect(page).to have_selector('li.workspace.home-item div.title', text: dataroom.name)
        expect(all('li.workspace.home-item div.chip.disabled', text: "ARCHIVED").count).to eq(1)
      end


      scenario 'restores an archived data room', testrail_id: 24_472 do
        selected_dataroom = find('li.workspace.home-item div.title', text: dataroom.name).ancestor('li.workspace.home-item')
        selected_dataroom.hover.find('li[oldtitle="Archive Data Room"]').click
        sleep(1)

        within 'div.ui-tooltip-focus' do
          find('a.button.ok').click
        end
        expect(all('li.workspace.home-item div.chip.disabled', text: "ARCHIVED").count).to eq(1)

        page.refresh

        find('input#show_archived').click
        selected_dataroom = find('li.workspace.home-item div.title', text: dataroom.name).ancestor('li.workspace.home-item')
        selected_dataroom.find('li[oldtitle="Restore Data Room"]').click
        within 'div.ui-tooltip-focus' do
          find('a.button.ok').click
          sleep(1)
        end

        page.refresh

        selected_dataroom = find('li.workspace.home-item div.title', text: dataroom.name).ancestor('li.workspace.home-item')
        expect(selected_dataroom).not_to have_selector('div.chip.disabled', text: "ARCHIVED")
      end


      scenario 'restore data room modal > verify permissions button navigates user to disabled data room' do
        selected_dataroom = find('li.workspace.home-item div.title', text: dataroom.name).ancestor('li.workspace.home-item')
        selected_dataroom.hover.find('li[oldtitle="Archive Data Room"]').click
        sleep(1)

        within 'div.ui-tooltip-focus' do
          find('a.button.ok').click
        end
        find('li.workspace.home-item div.chip.disabled', text: "ARCHIVED")
        page.refresh

        find('input#show_archived').click
        selected_dataroom = find('li.workspace.home-item div.title', text: dataroom.name).ancestor('li.workspace.home-item')
        selected_dataroom.find('li[oldtitle="Restore Data Room"]').click

        within 'div.ui-tooltip-focus' do
          find('a.button.secondary').click
        end

        expect(page).to have_selector('h1', text: "#{dataroom.name}")
        expect(page).to have_selector('body.data-room.branded.archived') #the striped background on disabled data rooms
      end

      #testrail needed
      #TODO check the top most scenario for checking actionmailer deliveries
      # need to explore a way to test email notifications without manually sending them inside the test
      # i tested this feature in staging manually and never got any update emails also...
      #scenario 'restore data room notification should send if box is checked' do
      #TODO iside the restore modal, there is a checkbox for sending a notification to users - if checked, restore should increments deliveries by 1
      #end
    end # home page / archiving data rooms


    #requires a message to be created in the previous test
    scenario 'deletes a workspace', testrail_id: 24_473 do
      starting_dataroom_count = all('li.workspace.home-item').count

      selected_dataroom = find('li.workspace.home-item div.title', text: dataroom.name).ancestor('li.workspace.home-item')
      accept_confirm do
        selected_dataroom.hover.find('li[oldtitle="Delete Data Room"]').click
      end

      expect(page).to have_selector('div.text-pairing', text: "The data room \"#{dataroom.name}\" has been deleted.")
      expect(all('li.workspace.home-item').count).to eq (starting_dataroom_count - 1)
      expect(page).not_to have_selector('li.workspace.home-item div.title', text: dataroom.name, wait: 3)
    end
  end #home page

  context "[inside data room tests]" do
    # Tests will assume <data room> is enabled unless in the <secure file storage> context
    context "[data room mode]" do
      before(:each) do
        dataroom.setup_first_run
        selenium_signin(user.email, 'atest', workspace_path(dataroom))
      end

      scenario 'sign in to a data room via data room url', testrail_id: 24_456 do
        expect(current_url).to include("/workspaces/#{dataroom.id}")
        expect(page).to have_selector('h1', text: dataroom.name)
      end


      #testrail needed
      scenario 'fail to sign in via data room url with a user that does NOT have access' do
        visit home_path
        selected_dr = find('li.workspace.home-item div.title', text: dataroom.name).ancestor('li.workspace.home-item')
        selected_dr.find('li.collaborators').click
        within 'div.ui-tooltip-focus' do
          expect(page).not_to have_selector('li.item div.name', text: "joseph joe")
          sleep(1)
          close_modal
        end
        selenium_signout

        selenium_signin('joe@joe.com', 'atest', workspace_path(dataroom))
        expect(page).to have_selector('div.alert.error', text: "Permission denied.")
        expect(current_url).to end_with('/home')
      end


      #testrail needed
      scenario "limiting the available pages in account settings <data room> will create new data rooms to match the configured settings" do
        visit edit_account_theme_path

        set_account_default_dataroom

        within 'section#edit_pages' do
          find('input#account_show_messages_false').click
          expect(page).to have_selector('input#account_show_files_true[disabled]')
        end

        find('li', text: 'Home').click
        create_dataroom('New Data Room')

        within 'nav.pages-navigation' do
          expect(all('ul.menu')[0].all('li').count).to eq(2)
          expect(page).not_to have_selector('li#messages_page', wait: 3)
        end
      end


      scenario 'enable data room mode', testrail_id: 24_460 do
        #this one needs to start in secure file storage
        visit workspace_path(sfs)

        find('li#options').click
        within 'div.ui-tooltip-focus' do
          expect(page).to have_select('workspace_data_room', selected: 'Secure File Storage')
        end

      end


      scenario 'change the data room name', testrail_id: 24_458 do
        expect(page).to have_selector('h1', text: dataroom.name)
        find('li#options').click

        within 'div.ui-tooltip-focus' do
          find('input#workspace_name').set('Changing this name to something NEW')
          find('button#save', text: 'Update Settings').click
        end

        expect(page).to have_selector('h1', text: 'Changing this name to something NEW')

        find('li', text: 'Home').click
        expect(page).to have_selector('li.workspace.home-item', text: 'Changing this name to something NEW')
      end


      scenario 'change the data room color via "theme" button', testrail_id: 24_465 do
        #50a332 : rgb = 80, 163, 50
        #004d66 : rgb = 0, 77, 102

        style = evaluate_script('window.getComputedStyle(document.querySelector("body")).getPropertyValue("background-color")')
        expect(style).to eq('rgb(80, 163, 50)')

        find('li#colors').click
        within 'div#theme_container' do
          find('input#workspace_background_color').set('#004d66')
          find('button#theme_submit', text: 'OK').click
          sleep(1)
        end

        #NOTE: normally would use page.refresh but there is a specific issue that occurs when calling refresh after updating the theme color...
        # It seems like there is a conflict between the update and the refresh - even when adding a longer wait time or looking for an element before the refresh
        # using returning to the home page and clicking back into the data room as an alternative... a page.refresh will now work but isn't required for the test

        visit home_path
        find('li.workspace.home-item div.title', text: dataroom.name).click
        expect(page).to have_selector('h1', text: dataroom.name)

        style = evaluate_script('window.getComputedStyle(document.querySelector("body")).getPropertyValue("background-color")')
        expect(style).to eq('rgb(0, 77, 102)')
      end


      scenario 'enable data room automatic indexing', testrail_id: 24_462 do
        allow($rollout).to receive(:active?).with('account:file_indexing_disabled', account).and_return(false)
        5.times do |i|
          create_folder("test#{i}")
          find('li.item.folder div.title', text: "test#{i}")
        end

        find('li#options').click
        within 'div.ui-tooltip-focus' do
          find('input#workspace_file_indexing').click
          sleep(1)
          find('button#save').click
        end

        sleep(3)
        # visit home_path
        # find('li.workspace.home-item div.title', text: dataroom.name).click
        page.refresh

        within 'main#files' do
          expect(all('li.item').count).to eq(6)
          all('li.item').each_with_index do |item, index|
            expect(item.find('div.title').text).to start_with("#{index + 1} ")
          end
        end
      end


      scenario 'include index in filename for downloads', testrail_id: 24_463 do
        #uses DonwloadHelpers
        clear_downloads

        allow($rollout).to receive(:active?).with('account:file_indexing_disabled', account).and_return(false)
        find('li#options').click
        within 'div.ui-tooltip-focus' do
          find('input#workspace_file_indexing').click

          sleep(1)
          find('button#save').click
        end

        sleep(3)
        visit home_path
        find('li.workspace.home-item div.title', text: dataroom.name).click


        download_item = find('li.item div.title', text: "1 Quick Start Guide.pdf")
        download_item.ancestor('li.item').find('li[oldtitle="Download"]').click

        sleep(2)

        expect(downloads.last).to end_with("Quick Start Guide.pdf")
        clear_downloads
      end


      scenario 'enable document watermarks', skip: "preview doesn't work well in local container", testrail_id: 24_461 do
        #TODO: need to find a way to allow preview file in the container
        # one option is to test on refresh, the watermark checkbox remains checked... but that isn't so useful against confirming the watermark on preview
        find('li#options').click
        within 'div.ui-tooltip-focus' do
          find('input#workspace_watermark').click
          sleep(1)
          find('button#save').click
        end

        item = find('li.item.file div.title', text: "Quick Start Guide.pdf")
        item_id = item.ancestor('li.item.file')['id'].split('-')[1]
        item.click

        expect(current_url).to include("/workspaces/#{dataroom.id}/files/#{item_id}")
        within 'div#preview' do
          expect(watermarks.count).to eq(2)
          expect(watermarks[0].text).to eq('CONFIDENTIAL')
          expect(watermarks[1].text).to eq("#{user.email}")
        end
      end


      scenario 'require a data room agreement', testrail_id: 24_464 do
        #TODO:
        # BEHAVIOR NOTE: if the agreement is viewed via "preview" feature, it will only appear once if accepted UNTIL agreement is changed.

        find('li#options').click
        within 'div.ui-tooltip-focus' do
          find('input#workspace_require_agreement').click

          within 'div.ck-editor__main' do
            find('p').click.send_keys(:clear).set("test agreement")
          end

          sleep(1)
          find('button#save').click
        end

        find('li', text: "Share").click
        within 'div.popover.flyout' do
          find('li#invite').click
        end

        within 'div.ui-tooltip-focus' do
          find('button', text: "Invite Users").click
          find('a.js-preview-link').click
          sleep(1)
        end

        expect(page).to have_selector('div.goggles-bar', visible: true)

        within 'div.ui-tooltip-agreement' do
          expect(page).to have_selector('div.insert', text: "test agreement")
          find('a.button', text: "Accept").click
        end

        expect(page).to have_selector('h1', text: dataroom.name)
        expect(page).not_to have_selector('div.ui-tooltip-agreement', visible: true, wait: 3)

      end


      context '[data room messages]' do
        def create_test_message
          find('a#new_message').click
          within 'div#new_message_form' do
            find('input#message_subject').set('Test Message')
            find('p.ck-placeholder').click.set("this is a new message")
            sleep(1)
            find('button', text: 'Create Message').click
          end
        end

        scenario 'post a new message', testrail_id: 24_475 do
          find('li#messages_page').click
          expect(current_url).to end_with("/messages")
          expect(page).to have_selector('h2', text: 'Post your first message.')

          create_test_message
          expect(page).to have_selector('div.text-pairing', text: "Message successfully posted!")

          expect(all('li.workspace-message').count).to eq(1)
          expect(page).to have_selector('li.workspace-message div.subject', text: 'Test Message')
          expect(page).to have_selector('li.workspace-message div.body', text: 'this is a new message')
          expect(page).not_to have_selector('h2', text: 'Post your first message.', wait: 3)
        end


        scenario 'delete a message', testrail_id: 24_477 do
          find('li#messages_page').click

          create_test_message

          selected_message = find('li.workspace-message div.subject', text: 'Test Message').ancestor('li.workspace-message')
          accept_confirm do
            selected_message.find('li.trash').click
          end

          expect(page).to have_selector('div.text-pairing', text: "Message succesfully deleted.")
          expect(all('li.workspace-message').count).to eq(0)
          expect(page).to have_selector('h2', text: 'Post your first message.')
        end


        #testrail needed
        scenario 'fail to delete a message as a user with creator or lower permissions' do
          find('li', text: 'Share').click
          within 'div.popover.flyout' do
            find('li#invite').click
          end

          within 'div.ui-tooltip-focus' do
            find('button.js-invite-btn', text: 'Invite Users').click
            find('textarea#invitation_emails').set('joe@joe.com')
            sleep(1)
            find('button[type="submit"]', text: 'Invite').click
            sleep(1)
            close_modal
          end

          find('li#messages_page').click
          create_test_message

          selenium_signout

          selenium_signin('joe@joe.com', 'atest', workspace_path(dataroom))
          find('li#messages_page').click

          expect(all('li.workspace-message').count).to eq(1)
          selected_message = find('li.workspace-message div.subject', text: 'Test Message').ancestor('li.workspace-message')
          selected_message.hover
          expect(selected_message).not_to have_selector('li.trash', wait: 3)


        end
      end # [data room mode] / data room messages


      #TODO: requires simulating email sends, not sure the best method to do this locally... check tests in review
      context '[data room exports]' do
        scenario 'export a data room index CSV', testrail_id: 24_466 do
          first_check =  ActionMailer::Base.deliveries.size

          find('li#export').click
          within 'div.ui-tooltip-focus' do
            all('div.info')[0].find('a.button', text: 'Download a CSV').click
          end
          #simulating send looking at workspace_mailer_spec
          # export = report_exports(:ready_folder_hierarchy_export)
          # WorkspaceMailer.folder_hierarchy(dataroom, export).deliver

          # simulating send via workspace method - used in previous test
          dataroom.email_file_list user

          second_check =  ActionMailer::Base.deliveries.size

          expect(page).to have_selector('div.text-pairing', text: "Your data room index export is being generated. You will receive an email shortly at #{user.email} once your export has been completed.")
          expect(second_check).to eq (first_check + 1)
        end


        scenario 'export a data room index PDF', testrail_id: 24_467 do
          first_check =  ActionMailer::Base.deliveries.size

          find('li#export').click
          within 'div.ui-tooltip-focus' do
            all('div.info')[0].find('a.button', text: 'Download a PDF').click
          end
          #simulating send looking at workspace_mailer_spec
          # export = report_exports(:ready_folder_hierarchy_export)
          # WorkspaceMailer.folder_hierarchy(dataroom, export).deliver

          # simulating send via workspace method - used in previous test
          dataroom.email_file_list user

          second_check =  ActionMailer::Base.deliveries.size

          expect(page).to have_selector('div.text-pairing', text: "Your data room index export is being generated. You will receive an email shortly at #{user.email} once your export has been completed.")
          expect(second_check).to eq (first_check + 1)
        end


        scenario 'export a data room metadata CSV', testrail_id: 24_468 do
          first_check =  ActionMailer::Base.deliveries.size

          find('li#export').click
          within 'div.ui-tooltip-focus' do
            all('div.info')[1].find('a.button', text: 'Download a CSV').click
          end
          expect(page).to have_selector('div.text-pairing', text: "Your data room metadata export is being generated. You will receive an email shortly at #{user.email} once your export has been completed.")
          #simulating send looking at workspace_mailer_spec
          #   export = report_exports(:ready_folder_hierarchy_export)
          #   WorkspaceMailer.folder_hierarchy(dataroom, export).deliver

          # simulating send via workspace method - used in previous test
          dataroom.email_file_list user

          second_check =  ActionMailer::Base.deliveries.size
          expect(second_check).to eq (first_check + 1)
        end
      end # [data room mode] / data room exports


      scenario 'disable all workspace notifications', testrail_id: 24_469 do
        #NOTE: updated language but the issue is still that notification emails can't be tested locally, hard
        # to test meaningfully

        find('li#options').click
        within 'div.ui-tooltip-focus' do
          find('input#workspace_enable_message_emails').click
          find('input#workspace_enable_comment_emails').click
          find('input#workspace_enable_file_activity_emails').click
          find('input#workspace_enable_task_emails').click
          sleep(1)
          find('button#save').click
        end

        sleep(1)
        page.refresh
        sleep(1)

        find('li#options').click
        within 'div.ui-tooltip-focus' do
          expect(page).to have_selector('h4', text: 'Settings')
          expect(page).not_to have_selector('input#workspace_enable_message_emails[checked="checked"]', wait: 3)
          expect(page).not_to have_selector('input#workspace_enable_comment_emails[checked="checked"]', wait: 3)
          expect(page).not_to have_selector('input#workspace_enable_file_activity_emails[checked="checked"]', wait: 3)
          expect(page).not_to have_selector('input#workspace_enable_task_emails[checked="checked"]', wait: 3)
        end
        expect(dataroom.reload.enable_message_emails).to be_falsy
        expect(dataroom.reload.enable_comment_emails).to be_falsy
        expect(dataroom.reload.enable_file_activity_emails).to be_falsy
        expect(dataroom.reload.enable_task_emails).to be_falsy
      end
    end # Data room end

    context "[secure file storage mode]" do
      before(:each) do
        selenium_signin(user.email, 'atest', workspace_path(sfs))
      end

      def set_all_sfs_pages_active
        find('li.profile.dropdown').click
        within 'div.popover.flyout' do
          find('li', text: 'Account Settings').click
        end
        find('li', text: 'Theme').click

        within 'table.interactive' do
          find('input#account_show_dashboard_true').click
          find('input#account_show_messages_true').click
          find('input#account_show_tasks_true').click
          find('input#account_show_files_true').click
          find('input#account_show_activity_true').click
        end
      end

      scenario "if account settings are set to <secure file storage>, the data room will be created in <secure file storage> mode" do
        visit home_path
        starting_count = all('li.workspace.home-item').count
        create_dataroom('New SFS Data Room')

        expect(page).to have_selector('div.text-pairing', text:  "Welcome to your new data room!")

        find('li#options').click
        within 'div.ui-tooltip-focus' do
          expect(page).to have_select('workspace_data_room', selected: 'Secure File Storage')
        end

        visit home_path
        expect(all('li.workspace.home-item').count).to eq(starting_count + 1)
      end


      scenario "limiting the available pages in account settings <secure file storage> will create new data rooms to match the configured settings", testrail_id: 24_474 do
        find('li.profile.dropdown').click
        within 'div.popover.flyout' do
          find('li', text: 'Account Settings').click
        end

        find('li', text: 'Theme').click
        within 'table.interactive' do
          find('input#account_show_dashboard_true').click
          find('input#account_show_files_false').click # files off disables "Whats's New" tab
          find('input#account_show_tasks_true').click
          find('input#account_show_messages_false').click
          find('input#account_show_activity_true').click
        end

        visit home_path
        create_dataroom('New SFS Data Room')

        selected_menu = find('nav.pages-navigation').all('ul.menu')[0]
        expect(selected_menu.all('li').count).to eq(3)

        expect(selected_menu).not_to have_selector('li#files_page', wait: 3)
        expect(selected_menu).not_to have_selector('li#messages_page', wait: 3)

        expect(selected_menu).to have_selector('li#dashboard_page')
        #       turned on ONLY when "Files" tab is on
        #       expect(selected_menu).to have_selector("li#what's new_page")
        expect(selected_menu).to have_selector('li#tasks_page')
        expect(selected_menu).to have_selector('li#activity_page')
      end


      scenario 'changes the default file view to <secure file storage>', testrail_id: 24_459 do
        set_all_sfs_pages_active

        select('Data Room', from: 'account_default_workspace_mode')

        visit home_path
        create_dataroom('New conversion Data Room')

        sleep(2)
        find('li#options').click
        within 'div.ui-tooltip-focus' do
          expect(page).to have_select('workspace_data_room', selected: 'Data Room')
          sleep(1)
          select('Secure File Storage', from: 'workspace_data_room')
          find('button#save').click
        end

        sleep(1)
        page.refresh
        sleep(1)


        selected_menu = find('nav.pages-navigation').all('ul.menu')[0]
        expect(selected_menu.all('li').count).to eq(6) #should be 6 if what's new

        expect(selected_menu).to have_selector('li#files_page')
        expect(selected_menu).to have_selector('li#messages_page')
        expect(selected_menu).to have_selector('li#dashboard_page')
        expect(selected_menu).to have_selector("li", text: "What's New") #issue with li id
        expect(selected_menu).to have_selector('li#tasks_page')
        expect(selected_menu).to have_selector('li#activity_page')
      end


      #routing error when trying to assert on the "page" after dashboard message is posted
      scenario 'creates a dashboard welcome message', broken: true, testrail_id: 24_478 do
        find('li.profile.dropdown').click
        within 'div.popover.flyout' do
          find('li', text: 'Account Settings').click
        end
        find('li', text: 'Theme').click

        within 'table.interactive' do
          find('input#account_show_dashboard_true').click
          find('input#account_show_messages_true').click
          find('input#account_show_tasks_true').click
          find('input#account_show_files_true').click
          find('input#account_show_activity_true').click
        end

        visit home_path

        create_dataroom('New SFS')
        find('li#dashboard_page').click

        expect(find('div.dashboard-welcome.first-run')).to have_selector('h2', text: 'Welcome Message')

        find('a#add_message').click
        find('textarea#edit_welcome_message').set('TEST SFS WELCOME MESSAGE')
        sleep(1)
        find('button', text: "Save").click

        binding.pry
        expect(page).to have_content('TEST SFS WELCOME MESSAGE')
=begin
    route error when calling expect on page:

     Failure/Error: @app.call(env)

     ActionController::RoutingError:
       No route matches [GET] "/favicon.ico"
=end

        # expect(find('div#dashboard')).to have_selector('div.dashboard-welcome', text: 'TEST SFS WELCOME MESSAGE')
        # expect(find('div#dashboard')).not_to have_selector('div.dashboard-welcome.first-run', wait: 3)
      end


      scenario 'comments a new message', testrail_id: 24_476 do
        find('li#messages_page').click
        selected_message = find('li.workspace-message')
        selected_message.hover.find('li.comments.modal').click


        within 'div.ui-tooltip-focus' do
          find('textarea#comment_body').set('test SFS comment on a message')
          sleep(1)
          find('button', text: 'Post').click

          expect(page).to have_selector('li.comment.item div.comment-text', text: "test SFS comment on a message")
          expect(page).to have_selector('div.footer', text: '2 comments')

          close_modal
        end

        selected_message = find('li.workspace-message')
        expect(selected_message.hover).to have_selector('li.comments.modal strong.count', text: '1')
      end
    end # sfs
  end # context
end # spec