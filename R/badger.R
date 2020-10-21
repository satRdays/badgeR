#' Make participant card
#'
#' @param first_name character with first name
#' @param second_name character with second name
#' @param role character with role at the event
#' @param extra character miscellaneous information, eg.
#' gender pronouns, email, etc
#'
#' @return character with confpin values filled in
#' @import glue
make_participant <- function(first_name, second_name = "", role = "", extra = "") {
  glue::glue("\\confpin{{{first_name}}}{{{second_name}}}{{{role}}}{{{extra}}}")
}


DEFAULT_TEMPLATE <- readLines("tex/default_template.tex") %>%
  glue::glue_collapse("\n")

#' Create badges
#'
#' This creates PDF with badges for your conference. It's saved in your default location.
#'
#' @param badges_data data.frame with fields: first (first name, mandatory),
#' second (second name), role (role at the event), extra (any additional
#' information, eg. e-mail, company, gender pronouns, etc.)
#' @param output_file_name character with output pdf file name
#' @param badge_width width (default: 52 [mm])
#' @param badge_height height (default: 78 [mm])
#' @param event_name character with name of your event (default "Event")
#' @param event_date character with date (default "")
#' @param cards_per_page vector of length 2 with number of badges per page (default c(2, 3))
#' @param graphic character with graphic path (default graphic inserted)
#' @param graphics_size graphics width ad unit (default "15mm")
#' @param edge_type edges that separate badges (default "crossmark")
#'
#' @export
#'
#' @examples
#' badges_data <- data.frame(first=c("AAAA", "BBBB"), # list of first names
#'                           second=c("XXXX", "ZZZZ"), # list of second names
#'                           role=c("speaker", "regular") # list of roles at the event
#'                           )
#' create_badges(badges_data)
#' @import dplyr
#' @import glue
create_badges <- function(badges_data, output_file_name = NULL,
                          badge_width = 52, badge_height = 78, event_name = "Event",
                          event_date = "", cards_per_page = c(2, 3), graphic = "ifmlogoc",
                          graphics_size = "15mm", edge_type = "crossmark"){
  edges <- c("crossmark", "circlemark", "emptycrossmark", "cutmark", "boxed")

  if (!(edge_type %in% edges))
      stop("Only following edge types work: crossmark, circlemark, emptycrossmark, cutmark, boxed")

  cards_per_page_x <- cards_per_page[[1]]
  cards_per_page_y <- cards_per_page[[2]]

  footer_pos_x <- 3
  footer_pos_y <- round(badge_height*0.23)
  logo_pos_x <- round(badge_width*0.66)

  main_text_x <- round(badge_width/2)
  main_text_y <- round(badge_height/2)

  options(warn=-1)
  for (col in c("second", "role", "extra")) {
    if (! col%in% colnames(badges_data))
      badges_data[[col]] <- ""
  }
  cards <- paste((badges_data %>%
                    rowwise() %>%
                    mutate(cardcode = make_participant(first, second, role, extra)))$cardcode,
                 collapse = "\n")
  options(warn=0)
  s <- glue::glue(DEFAULT_TEMPLATE)

  temp_badge_code <- tempfile("badge", tmpdir=".", fileext=".tex")
  writeLines(s, con = temp_badge_code)
  tools::texi2dvi(temp_badge_code, pdf = TRUE, clean = TRUE)
  file.remove(temp_badge_code)
  if (!is.null(output_file_name))
    file.rename(gsub(".tex$", ".pdf", temp_badge_code), output_file_name)
}
