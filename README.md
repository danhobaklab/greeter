# greeter
<img src="https://raw.githubusercontent.com/danhobaklab/greeter/master/images/title.png"><br>
<i>Gesture-based Interactive Greeter for Department Device Checkout</i> <br>
<b>Project page: </b><a href="http://dahyepark.com/projects/greeter/greeter.html">http://dahyepark.com/projects/greeter/greeter.html</a>
<h3>Outline</h3>
<p>As a part of my thesis research, I was looking for problems surrounding my life. And the most annoying thing in the studio was being asked to help check out items by other students. It would be okay if it was my shift, but basically, students always came to me to ask for help. Because I was one of a few people working in the studio. Furthermore, there was a shift schedule on the door of checkout closet, they came to me ask who was working at checkout. So, I decided to build a checkout greeter, an interactive screen showing who’s working at checkout, when it detects the visitor.</p>
<h3>Structure</h3>
<img src="https://raw.githubusercontent.com/danhobaklab/greeter/master/images/greeter-structure.png"><br>
<p>To build the greeter, I used <a href="https://www.microsoft.com/en-us/kinectforwindows/develop/" target="_blank">Kinect V2</a>, <a href="https://processing.org/">Processing</a>, <a href="https://github.com/ThomasLengeling/KinectPV2" target="_blank">KinectPV2 Library</a>, and TV in the lobby of the department. The new Kinect can detect users quicker than a previous one and also has a better skeleton scan. Processing will analyze gestures of the user and show a proper response on the TV screen. As TV is faced to the elevator, Kinect built on the TV can detect visitors when they arrive at the floor.</p>
<p>Below shows how the greeter works. At first. the greeter waits for the visitor and shows random hello message or information message to attract visitors. When a visitor stands in front of the screen, the greeter greets the visitor and asks friendly questions like ‘How’s it going?’ After the visitor responses to the greeter’s question and the greeter also responses to him, it asks whether he wants to checkout. When the visitor replies that question, then the greeter shows information based on his answer.</p>
<img src="https://raw.githubusercontent.com/danhobaklab/greeter/master/images/greeter-algorithm.png"><br>
<p>And here are screen samples that the greeter shows to visitors.</p>
<h5>State 0. Waiting</h5>
<img src="https://raw.githubusercontent.com/danhobaklab/greeter/master/images/greeter-01.png"><br>
<h5>State 1. Greeting</h5>
<img src="https://raw.githubusercontent.com/danhobaklab/greeter/master/images/greeter-02.png"><br>
<h5>State 2. Response</h5>
<img src="https://raw.githubusercontent.com/danhobaklab/greeter/master/images/greeter-03.png"><br>
<h5>State 3. Question / State 4. Answer</h5>
<img src="https://raw.githubusercontent.com/danhobaklab/greeter/master/images/greeter-04.png"><br>
