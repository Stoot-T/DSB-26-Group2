#Sequence 1
ggplot(Seq1)
ggplot(Seq1, aes(x= rname,
                 y= coverage,
                 colour = Coverage)) +
  
  
  geom_bar(stat = "identity", 
           colour = "steelblue",
           fill = "steelblue") +
  
  geom_line(aes(y = meandepth * 100, group = 1), colour = "forestgreen", size = 1) +
  geom_point(aes(y = meandepth * 100), colour = "forestgreen", size = 1) +
  
  scale_y_continuous(
    name = "Coverage Value", 
    sec.axis = sec_axis(~ . / 100, name = "Mean Depth")) +
  
  scale_fill_manual(values = c("Coverage" = "steelblue")) +
  scale_color_manual(values = c("Mean Depth" = "forestgreen")) +
  
  labs(
    title = "ERR145618",
    x = "Chromosome",      
    y = "Coverage Value"
  ) +
  
  theme_bw() +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_blank(),
    axis.line = element_line(colour = "black"),
    axis.title = element_text(face = "bold"),
    plot.title = element_text(hjust = 0.5, size = 20))




chr_order <- c(paste0(1:22), "X", "Y" )

Seq1$rname <- factor(Seq1$rname, levels = chr_order)

#Sequence 2

ggplot(Seq2)
ggplot(Seq2, aes(x= rname,
                 y= coverage,
                 colour = Coverage)) +
  
  
  geom_bar(stat = "identity", 
           colour = "steelblue",
           fill = "steelblue") +
  
  geom_line(aes(y = meandepth * 100, group = 1), colour = "forestgreen", size = 1) +
  geom_point(aes(y = meandepth * 100), colour = "forestgreen", size = 1) +
  
  scale_y_continuous(
    name = "Coverage Value", 
    sec.axis = sec_axis(~ . / 100, name = "Mean Depth")) +
  
  scale_fill_manual(values = c("Coverage" = "steelblue")) +
  scale_color_manual(values = c("Mean Depth" = "forestgreen")) +
  
  labs(
    title = "ERR145620",
    x = "Chromosome",      
    y = "Coverage Value"
  ) +
  
  theme_bw() +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_blank(),
    axis.line = element_line(colour = "black"),
    axis.title = element_text(face = "bold"),
    plot.title = element_text(hjust = 0.5, size = 20))




chr_order <- c(paste0(1:22), "X", "Y" )

Seq2$rname <- factor(Seq1$rname, levels = chr_order)

#Sequence 3
ggplot(Seq3)
ggplot(Seq3, aes(x= rname,
                 y= coverage,
                 colour = Coverage)) +
  
  
  geom_bar(stat = "identity", 
           colour = "steelblue",
           fill = "steelblue") +
  
  geom_line(aes(y = meandepth * 100, group = 1), colour = "forestgreen", size = 1) +
  geom_point(aes(y = meandepth * 100), colour = "forestgreen", size = 1) +
  
  scale_y_continuous(
    name = "Coverage Value", 
    sec.axis = sec_axis(~ . / 100, name = "Mean Depth")) +
  
  scale_fill_manual(values = c("Coverage" = "steelblue")) +
  scale_color_manual(values = c("Mean Depth" = "forestgreen")) +
  
  labs(
    title = "ERR145622",
    x = "Chromosome",      
    y = "Coverage Value"
  ) +
  
  theme_bw() +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_blank(),
    axis.line = element_line(colour = "black"),
    axis.title = element_text(face = "bold"),
    plot.title = element_text(hjust = 0.5, size = 20))




chr_order <- c(paste0(1:22), "X", "Y" )

Seq3$rname <- factor(Seq1$rname, levels = chr_order)

#Sequence 4
ggplot(Seq4)
ggplot(Seq4, aes(x= rname,
                 y= coverage,
                 colour = Coverage)) +
  
  
  geom_bar(stat = "identity", 
           colour = "steelblue",
           fill = "steelblue") +
  
  geom_line(aes(y = meandepth * 100, group = 1), colour = "forestgreen", size = 1) +
  geom_point(aes(y = meandepth * 100), colour = "forestgreen", size = 1) +
  
  scale_y_continuous(
    name = "Coverage Value", 
    sec.axis = sec_axis(~ . / 100, name = "Mean Depth")) +
  
  scale_fill_manual(values = c("Coverage" = "steelblue")) +
  scale_color_manual(values = c("Mean Depth" = "forestgreen")) +
  
  labs(
    title = "ERR145624",
    x = "Chromosome",      
    y = "Coverage Value"
  ) +
  
  theme_bw() +
  theme(
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    panel.border = element_blank(),
    axis.line = element_line(colour = "black"),
    axis.title = element_text(face = "bold"),
    plot.title = element_text(hjust = 0.5, size = 20))




chr_order <- c(paste0(1:22), "X", "Y" )

Seq4$rname <- factor(Seq1$rname, levels = chr_order)

