library(ggplot2)
library(cowplot)
library(gridExtra)
library(rowr)
library(TSdist)
library(signal)
library(scales)

# Read Data File
a <- read.csv("exampleA.csv", header = TRUE)
b <- read.csv("exampleB.csv", header = TRUE)

# Select Required Data
data_a <- a[, c("LinearAcc0", "LinearAcc1", "LinearAcc2")]
names(data_a) <- c("x", "y", "z")

data_b <- b[, c("LinearAcc0", "LinearAcc1", "LinearAcc2")]
names(data_b) <- c("x", "y", "z")

# PCA
data_a.pca <- prcomp(data_a, scale = FALSE, retx = TRUE)
summary(data_a.pca)

data_b.pca <- prcomp(data_b, scale = FALSE, retx = TRUE)
summary(data_b.pca)

# Get PCA result to Data Frame
pca_a <- as.data.frame(data_a.pca$x)
names(pca_a) <- c("PC1_A", "PC2_A", "PC3_A")

pca_b <- as.data.frame(data_b.pca$x)
names(pca_b) <- c("PC1_B", "PC2_B", "PC3_B")

# Unlist data
x <- as.character(unlist(a["Timestamp"]))
y <- as.numeric(unlist(pca_a["PC1_A"]))
y2 <- as.numeric(unlist(pca_b["PC1_B"]))

# Create butterworth filter and filt data
bf <- butter(4, 1 / 10, type = "pass") # The paramters here need to modify based on the data. No commendatory.
y <- filter(bf, y)
y2 <- filter(bf, y2)

# Caculate the correlation
cor <- vector()
cache <- 0
WINDOWS_SIZE <- 40 #40
OVERLAP <- 9 #19
WINDOWS_SIZE <- WINDOWS_SIZE - 1
for (i in seq(1, length(y) - WINDOWS_SIZE, by = OVERLAP)) {
  xx <- y[i:(i + WINDOWS_SIZE)]
  yy <- y2[i:(i + WINDOWS_SIZE)]
  s <- cor(x = xx, y = yy, use = "everything", method = "spearman")
  j <- i + floor(WINDOWS_SIZE / 2)
  cor[j] <- s * 1
  cache <- i
}

# Merge data
result <- cbind.fill(x, y, y2, cor)
names(result) <- c("time", "PCA_a", "PCA_b", "cor")
df <- data.frame(result["time"], result["PCA_a"], result["PCA_b"], result["cor"])

#Convert timestamp format
time <- gsub(":", ".", x)
time <- strptime(time, format = "%H.%M.%OS")
time <- as.POSIXct(time)
df["time"] <- time

# Correlation Plot
SCALE <- 6
p1 <- ggplot(df) +
  geom_hline(aes(yintercept = 0)) +
  scale_x_datetime(name = "Time", labels = date_format("%H:%M:%OS")) +
  scale_y_continuous(name = "Correlation", limits = c(-2, 2), sec.axis = sec_axis(~. * SCALE, name = "PCA")) +
  scale_colour_manual("", values = c("PCA_A" = "hotpink", "PCA_B" = "steelblue", "Correlation" = "chocolate")) +
  geom_line(aes(x = time, y = PCA_a / SCALE, group = 1, colour = "PCA_A"), size = 0) +
  geom_line(aes(x = time, y = PCA_b / SCALE, group = 1, colour = "PCA_B"), size = 0) +
  geom_hline(aes(yintercept = 1), linetype = "dashed", color = "tomato") +
  geom_hline(aes(yintercept = -1), linetype = "dashed", color = "tan2") +
  geom_step(data = na.omit(df), aes(x = time, y = cor, group = 1, color = "Correlation"), size = 1.3) +
  theme(text = element_text(size = 23), plot.title = element_text(hjust = 0.5)) +
  ggtitle("Correlation")

# Person A Plot
p2 <- ggplot(df) +
  scale_x_datetime(name = "Time", labels = date_format("%H:%M:%OS")) +
  ylab("PCA") +
  geom_hline(aes(yintercept = 0)) +
  scale_colour_manual("", values = c("PCA_A" = "hotpink3", "PCA_B" = "steelblue", "Correlation" = "chocolate")) +
  geom_line(aes(x = time, y = PCA_a, group = 1, colour = "PCA_A"), size = 0) +
  theme(text = element_text(size = 23), plot.title = element_text(hjust = 0.5)) +
  ggtitle("PCA_One")

# Person B Plot
p3 <- ggplot(df) +
  scale_x_datetime(name = "Time", labels = date_format("%H:%M:%OS")) +
  ylab("PCA") +
  geom_hline(aes(yintercept = 0)) +
  scale_colour_manual("", values = c("PCA_A" = "hotpink3", "PCA_B" = "steelblue3", "Correlation" = "chocolate")) +
  geom_line(aes(x = time, y = PCA_b, group = 1, colour = "PCA_B"), size = 0) +
  theme(text = element_text(size = 23), plot.title = element_text(hjust = 0.5)) +
  ggtitle("PCA_Two")

# Merge and save plot
plot_grid(plot_grid(p2, p3), p1, ncol = 1)
ggsave("output_plot.pdf")


