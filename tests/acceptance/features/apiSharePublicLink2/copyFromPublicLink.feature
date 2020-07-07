@api @files_sharing-app-required @public_link_share-feature-required @issue-ocis-reva-310
Feature: copying from public link share

  Background:
    Given user "Alice" has been created with default attributes and without skeleton files
    And user "Alice" has created folder "/PARENT"
    And the administrator has enabled DAV tech_preview

  Scenario: Copy file within a public link folder new public WebDAV API
    Given user "Alice" has uploaded file with content "some data" to "/PARENT/testfile.txt"
    And user "Alice" has created a public link share with settings
      | path        | /PARENT                   |
      | permissions | read,update,create,delete |
    When user "Alice" copies file "/testfile.txt" to "/copy1.txt" using the new public WebDAV API
    Then the HTTP status code should be "201"
    And as "Alice" file "/PARENT/testfile.txt" should exist
    And as "Alice" file "/PARENT/copy1.txt" should exist
    And the content of file "/PARENT/testfile.txt" for user "Alice" should be "some data"
    And the content of file "/PARENT/copy1.txt" for user "Alice" should be "some data"

  Scenario: Copy folder within a public link folder new public WebDAV API
    Given user "Alice" has created folder "/PARENT/testFolder"
    And user "Alice" has uploaded file with content "some data" to "/PARENT/testFolder/testfile.txt"
    And user "Alice" has created a public link share with settings
      | path        | /PARENT                   |
      | permissions | read,update,create,delete |
    When user "Alice" copies folder "/testFolder" to "/testFolder-copy" using the new public WebDAV API
    Then the HTTP status code should be "201"
    And as "Alice" folder "/PARENT/testFolder" should exist
    And as "Alice" folder "/PARENT/testFolder-copy" should exist
    And the content of file "/PARENT/testFolder/testfile.txt" for user "Alice" should be "some data"
    And the content of file "/PARENT/testFolder-copy/testfile.txt" for user "Alice" should be "some data"

  Scenario: Copy file inside a folder within a public link folder new public WebDAV API
    Given user "Alice" has uploaded file with content "some data" to "/PARENT/testfile.txt"
    And user "Alice" has created folder "/PARENT/testFolder"
    And user "Alice" has created a public link share with settings
      | path        | /PARENT                   |
      | permissions | read,update,create,delete |
    When user "Alice" copies file "/testfile.txt" to "/testFolder/copy1.txt" using the new public WebDAV API
    Then the HTTP status code should be "201"
    And as "Alice" file "/PARENT/testfile.txt" should exist
    And as "Alice" file "/PARENT/testFolder/copy1.txt" should exist
    And the content of file "/PARENT/testfile.txt" for user "Alice" should be "some data"
    And the content of file "/PARENT/testFolder/copy1.txt" for user "Alice" should be "some data"

  Scenario: Copy file within a public link to same file name as already exiting one
    Given user "Alice" has uploaded file with content "some data 0" to "/PARENT/testfile.txt"
    And user "Alice" has uploaded file with content "some data 1" to "/PARENT/copy1.txt"
    And user "Alice" has created a public link share with settings
      | path        | /PARENT                   |
      | permissions | read,update,create,delete |
    When user "Alice" copies file "/testfile.txt" to "/copy1.txt" using the new public WebDAV API
    Then the HTTP status code should be "204"
    And as "Alice" file "/PARENT/testfile.txt" should exist
    And as "Alice" file "/PARENT/copy1.txt" should exist
    And the content of file "/PARENT/copy1.txt" for user "Alice" should be "some data 0"

  Scenario: Copy file within a public link folder and delete file
    Given user "Alice" has uploaded file with content "some data" to "/PARENT/testfile.txt"
    And user "Alice" has created a public link share with settings
      | path        | /PARENT                   |
      | permissions | read,update,create,delete |
    When user "Alice" copies file "/testfile.txt" to "/copy1.txt" using the new public WebDAV API
    And user "Alice" deletes file "/PARENT/copy1.txt" using the WebDAV API
    Then the HTTP status code should be "204"
    And as "Alice" file "/PARENT/copy1.txt" should not exist

  Scenario: Copy file within a public link folder and reshare with other user
    Given user "Brian" has been created with default attributes and without skeleton files
    And user "Alice" has uploaded file with content "some data" to "/PARENT/testfile.txt"
    And user "Alice" has created a public link share with settings
      | path        | /PARENT                         |
      | permissions | read,update,create,delete,share |
    When user "Alice" copies file "/testfile.txt" to "/copy1.txt" using the new public WebDAV API
    And user "Alice" shares file "/PARENT/copy1.txt" with user "Brian" using the sharing API
    Then the HTTP status code should be "200"
    And as "Brian" file "/copy1.txt" should exist
