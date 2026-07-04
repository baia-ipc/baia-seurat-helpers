\name{strsanitize}
\alias{strsanitize}
\title{Sanitize a string for filesystem-friendly names}
\usage{
strsanitize(s)
}
\arguments{
\item{s}{Character vector to sanitize.}
}
\value{
A character vector with sanitized strings.
}
\description{
Replaces non-alphanumeric characters with underscores, then replaces spaces
with underscores.
}
