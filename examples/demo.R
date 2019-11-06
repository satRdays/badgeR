badges_data <- data.frame(first=paste("User",1:8, sep = ""),
                          second=LETTERS[1:8],
                          role=rep.int(c("speaker", "regular"), 4))

create_badges(badges_data, output_file_name = "my_conference_badges.pdf")

create_badges(badges_data, event_name = "My Conference", event_date = "01/10/2010",
              output_file_name = "my_conference_badges.pdf")
