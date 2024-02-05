import 'package:flutter/material.dart';
import 'package:giro_driver_app/theme/typography/text_styles.dart';


class DisplayText extends Text{
  const DisplayText(super.data,{Key? key}):super(
    key: key,
    style: displayStyle,
    textAlign: TextAlign.center, 
  );
}
class H1 extends Text{
  const H1(super.data,{Key? key}):super(
    key: key,
    style: heading1Style
  );
}
class H2 extends Text{
  const H2(super.data,{Key? key}):super(
   
    key: key,
    style: heading2Style
  );
}
class H3 extends Text{
  const H3(super.data,{Key? key}):super(
     maxLines: 2, 
     textAlign: TextAlign.start, 
    overflow: TextOverflow.ellipsis,  
    key: key,
    style: heading3Style
  );
}
class Headline extends Text{
  const Headline(super.data,{Key? key}):super(
    key: key,
    style: headlineStyle
  );
}
class SubHeading extends Text{
  const SubHeading(super.data,{Key? key}):super(
    key: key,
    style: subheadingStyle
  );
}
class BodyText extends Text{
  const BodyText(super.data,{Key? key}):super(
    key: key,
     textAlign: TextAlign.start, 
 
    style: bodyStyle,
  );
   const BodyText.bold(super.data,{Key? key}):super(
    key: key,
    style: bodyStyleBold,
  );
  const BodyText.bPrimary(super.data,{Key? key}):super(
    key: key,
    style: bodyStyleBoldPrimary,
  );

}
class Caption extends Text{
  const Caption(super.data,{Key? key}):super(
    key: key,
    style: captionStyle
    
  );
}