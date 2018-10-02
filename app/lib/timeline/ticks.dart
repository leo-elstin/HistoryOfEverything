import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';

class Ticks
{
	static const double Margin = 20.0;
	static const double Width = 40.0;
	static const double Gutter = 45.0;
	static const int TickDistance = 16;
	static const int TextTickDistance = 64;
	static const double TickSize = 15.0;
	static const double SmallTickSize = 5.0;

	void paint(PaintingContext context, Offset offset, double translation, double scale, double height)
	{
		final Canvas canvas = context.canvas;

		double bottom = height + Margin;
		double tickDistance = TickDistance.toDouble();
		double textTickDistance = TextTickDistance.toDouble();

		double scaledTickDistance = tickDistance * scale;
		while(scaledTickDistance < TickDistance)
		{
			scaledTickDistance *= 2;
			tickDistance *= 2;
			textTickDistance *= 2;
		}
		int numTicks = (height / scaledTickDistance).ceil()+2;

		// Figure out the position of the top left corner of the screen
		double tickOffset = 0.0;
		double startingTickMarkValue = 0.0;

		double y = ((translation-bottom)/scale);
		startingTickMarkValue = y-(y%tickDistance);
		tickOffset = -(y%tickDistance)*scale-scaledTickDistance;

		// Move back by one tick.
		tickOffset -= scaledTickDistance;
		startingTickMarkValue -= tickDistance;

		canvas.save();
		
		final Paint tickPaint = new Paint()..color = Color.fromRGBO(0, 0, 0, 0.3);
		final Paint smallTickPaint = new Paint()..color = Color.fromRGBO(0, 0, 0, 0.1);
		canvas.drawRect(Rect.fromLTWH(offset.dx, offset.dy, Gutter, height), smallTickPaint);
		
		for(int i = 0; i < numTicks; i++)
		{
			tickOffset += scaledTickDistance;
			
			int tt = startingTickMarkValue.round();
			tt = -tt;
			int o = tickOffset.floor();
			if(tt%textTickDistance == 0)
			{
				canvas.drawRect(Rect.fromLTWH(offset.dx+Gutter-TickSize, offset.dy+height-o, TickSize, 1.0), tickPaint);
				ui.ParagraphBuilder builder = new ui.ParagraphBuilder(new ui.ParagraphStyle(
					textAlign:TextAlign.start,
					fontFamily: "Arial",
					fontSize: 10.0
				))..pushStyle(new ui.TextStyle(color:const Color.fromRGBO(0, 0, 0, 0.6)));
				builder.addText((tt).toStringAsFixed(2));
				ui.Paragraph tickParagraph = builder.build();
				tickParagraph.layout(new ui.ParagraphConstraints(width: Gutter));			
				canvas.drawParagraph(tickParagraph, new Offset(offset.dx + Gutter - tickParagraph.minIntrinsicWidth-2, offset.dy + height - o - tickParagraph.height - 5));
			}
			else
			{
				canvas.drawRect(Rect.fromLTWH(offset.dx+Gutter-SmallTickSize, offset.dy+height-o, SmallTickSize, 1.0), smallTickPaint);
			}
			startingTickMarkValue += tickDistance;
		}
	}
}