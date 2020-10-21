#' Basic usage with two arguments:
#'  - first with First Name
#'  - last with last name
badges_data <- data.frame(first=paste("User",1:8, sep = ""),
                          second=LETTERS[1:8],
                          role=rep.int(c("speaker", "regular"), 4))

create_badges(badges_data, output_file_name = "my_conference_badges1.pdf")

#' Customized badge with additional fields in data object:
#'  - role for role at the conference
#'  - extra with extra information, eg. gender pronouns, email , company, etc.
#'  Extra parameters are passed also to the function to change the size of
#'  the page, define the title, date and add the logo.
badges_data <- data.frame(first=paste("User",1:8, sep = ""),
                          second=LETTERS[1:8],
                          role=rep.int(c("speaker", "regular"), 4),
                          extra=rep(c("she/her", "he/him"), 4)
                          )

create_badges(badges_data,
              event_date = "01/10/2010",
              badge_width = 70, badge_height = 90,
              event_name = "Super Conference",
              graphic = system.file("satrdays_logo.png", package = "badgeR"),
              output_file_name = "my_conference_badges2.pdf")
