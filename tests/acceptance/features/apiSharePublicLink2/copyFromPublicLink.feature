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

  Scenario: Copy file within a public link folder to a new folder
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

  Scenario: Copy file within a public link folder to same file name as already exiting one
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

  Scenario: Copy folder within a public link folder to same folder name as already exiting one
    Given user "Alice" has created folder "/PARENT/testFolder"
    And user "Alice" has uploaded file with content "some data" to "/PARENT/testFolder/testfile.txt"
    And user "Alice" has uploaded file with content "some data" to "/PARENT/copy1.txt"
    And user "Alice" has created a public link share with settings
      | path        | /PARENT                   |
      | permissions | read,update,create,delete |
    When user "Alice" copies folder "/testFolder" to "/copy1.txt" using the new public WebDAV API
    Then the HTTP status code should be "204"
    And as "Alice" folder "/PARENT/testFolder" should exist
    And as "Alice" folder "/PARENT/copy1.txt" should exist
    And the content of file "/PARENT/testFolder/testfile.txt" for user "Alice" should be "some data"
    And the content of file "/PARENT/copy1.txt/testfile.txt" for user "Alice" should be "some data"

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

  Scenario: Copy file within a public link folder to a file with name same as of existing folder
    Given user "Alice" has uploaded file with content "some data" to "/PARENT/testfile.txt"
    And user "Alice" has created folder "/new-folder"
    And user "Alice" has created a public link share with settings
      | path        | /PARENT                   |
      | permissions | read,update,create,delete |
    When user "Alice" copies file "/testfile.txt" to "/new-folder" using the new public WebDAV API
    Then the HTTP status code should be "201"
    And as "Alice" file "/PARENT/testfile.txt" should exist
    And as "Alice" file "/PARENT/new-folder" should exist
    And the content of file "/PARENT/testfile.txt" for user "Alice" should be "some data"
    And the content of file "/PARENT/new-folder" for user "Alice" should be "some data"

  Scenario Outline: Copy file with special characters in it's name within a public link folder
    Given user "Alice" has uploaded file with content "some data" to "/PARENT/<destination-file-name>"
    And user "Alice" has created a public link share with settings
      | path        | /PARENT                   |
      | permissions | read,update,create,delete |
    When user "Alice" copies file "/<destination-file-name>" to "/copy1.txt" using the new public WebDAV API
    Then the HTTP status code should be "201"
    And as "Alice" file "/PARENT/<destination-file-name>" should exist
    And as "Alice" file "/PARENT/copy1.txt" should exist
    And the content of file "/PARENT/<destination-file-name>" for user "Alice" should be "some data"
    And the content of file "/PARENT/copy1.txt" for user "Alice" should be "some data"
    Examples:
      | destination-file-name |
      | नेपाली.txt            |
      | strängé file.txt      |
      | C++ file.cpp          |
#      | file #2.txt           |
#      | file ?2.txt           |

  Scenario Outline: Copy file within a public link folder to a file with special characters in it's name
    Given user "Alice" has uploaded file with content "some data" to "/PARENT/testfile.txt"
    And user "Alice" has created a public link share with settings
      | path        | /PARENT                   |
      | permissions | read,update,create,delete |
    When user "Alice" copies file "/testfile.txt" to "/<destination-file-name>" using the new public WebDAV API
    Then the HTTP status code should be "201"
    And as "Alice" file "/PARENT/testfile.txt" should exist
    And as "Alice" file "/PARENT/<destination-file-name>" should exist
    And the content of file "/PARENT/testfile.txt" for user "Alice" should be "some data"
    And the content of file "/PARENT/<destination-file-name>" for user "Alice" should be "some data"
    Examples:
      | destination-file-name |
      | नेपाली.txt            |
      | strängé file.txt      |
      | C++ file.cpp          |
#      | file #2.txt           |
#      | file ?2.txt           |

  Scenario Outline: Copy file within a public link folder to a folder with special characters
    Given user "Alice" has uploaded file with content "some data" to "/PARENT/testfile.txt"
    And user "Alice" has created folder "/PARENT/<destination-file-name>"
    And user "Alice" has created a public link share with settings
      | path        | /PARENT                   |
      | permissions | read,update,create,delete |
    When user "Alice" copies file "/testfile.txt" to "/<destination-file-name>/copy1.txt" using the new public WebDAV API
    Then the HTTP status code should be "201"
    And as "Alice" file "/PARENT/testfile.txt" should exist
    And as "Alice" file "/PARENT/<destination-file-name>/copy1.txt" should exist
    And the content of file "/PARENT/testfile.txt" for user "Alice" should be "some data"
    And the content of file "/PARENT/<destination-file-name>/copy1.txt" for user "Alice" should be "some data"
    Examples:
      | destination-file-name |
      | नेपाली.txt            |
      | strängé file.txt      |
      | C++ file.cpp          |

  Scenario Outline: Copy file within a public link folder to a file with unusual destination names
    Given user "Alice" has uploaded file with content "some data" to "/PARENT/testfile.txt"
    And user "Alice" has created a public link share with settings
      | path        | /PARENT                   |
      | permissions | read,update,create,delete |
    When user "Alice" copies file "/testfile.txt" to "/<destination-file-name>" using the new public WebDAV API
    Then the HTTP status code should be "403"
    And as "Alice" file "/PARENT/testfile.txt" should exist
    And the content of file "/PARENT/testfile.txt" for user "Alice" should be "some data"
    Examples:
      | destination-file-name |
      | testfile.txt          |
      |                       |

  Scenario Outline: Copy folder within a public link folder to a folder with unusual destination names
    Given user "Alice" has created folder "/PARENT/testFolder"
    And user "Alice" has uploaded file with content "some data" to "/PARENT/testFolder/testfile.txt"
    And user "Alice" has created a public link share with settings
      | path        | /PARENT                   |
      | permissions | read,update,create,delete |
    When user "Alice" copies folder "/testFolder" to "/<destination-file-name>" using the new public WebDAV API
    Then the HTTP status code should be "403"
    And as "Alice" folder "/PARENT/testFolder" should exist
    And the content of file "/PARENT/testFolder/testfile.txt" for user "Alice" should be "some data"
    Examples:
      | destination-file-name |
      | testFolder            |
      |                       |
