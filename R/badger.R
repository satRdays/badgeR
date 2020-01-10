library(glue)
library(dplyr)

#' Make participant card
#'
#' @param first_name character with first name
#' @param second_name character with second name
#' @param role character with role at the event
#'
#' @return character with confpin values filled in
make_participant <- function(first_name, second_name = "", role = "") {
  glue::glue("\\confpin{{{first_name}}}{{{second_name}}}{{{role}}}")
}

DEFAULT_TEMPLATE <- "
\\documentclass[a4paper,10pt]{{letter}}
\\usepackage[utf8]{{inputenc}}
\\usepackage[freepin,{edge_type}]{{ticket}}
\\usepackage{{graphicx}}

\\unitlength=1mm
\\ticketSize{{{badge_width}}}{{{badge_height}}}
\\ticketNumbers{{{cards_per_page_x}}}{{{cards_per_page_y}}}

\\renewcommand{{\\ticketdefault}}{{
\\put({logo_pos_x},  {footer_pos_y-12}){{\\includegraphics[width={graphics_size}]{{{graphic}}}}}
\\put(0, {footer_pos_y}){{\\line(1,0){{{badge_width}}}}}
\\put( 3,  {footer_pos_y-4}){{\\bfseries\\footnotesize {event_name}}}
\\put( 3,  {footer_pos_y-8}){{\\footnotesize {event_date}}}
}}

% now what do you like to put in your ticket
\\newcommand{{\\confpin}}[3]{{\\ticket{{%
\\put({main_text_x},{main_text_y+20}){{\\makebox[0mm]{{\\bfseries\\huge #1}}}}
\\put({main_text_x},{main_text_y+10}){{\\makebox[0mm]{{\\bfseries\\huge #2}}}}
\\put({main_text_x},{main_text_y}){{\\makebox[0mm]{{\\large \\textit{{#3}}}}}}
}}}}

\\begin{{document}}
\\sffamily
{cards}
\\end{{document}}
"

#' Create badges
#'
#' This creates PDF with badges for your conference. It's saved in your default location.
#'
#' @param badges_data data.frame with fields: first (first name), second (second name),
#' role (role at the event)
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
  logo_pos_x <- round(badge_width*0.63)

  main_text_x <- round(badge_width/2)
  main_text_y <- round(badge_height/2)

  options(warn=-1)
  cards <- paste((badges_data %>%
                    rowwise() %>%
                    mutate(cardcode=make_participant(first, second, role)))$cardcode,
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
